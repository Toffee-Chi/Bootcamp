import SwiftData
import SwiftUI
import PhotosUI

@MainActor
final class LeaveViewModel: ObservableObject {
    
    @Published var employeeName = ""
    @Published var startDate = Date() {
        didSet { updateAutoCalculatedDates() }
    }
    @Published var endDate = Date()
    @Published var selectedLeaveType: LeaveType? {
        didSet { resetTypeSpecificFields() }
    }
    @Published var selectedLicenseSubtype: LicenseSubtype? {
        didSet { updateAutoCalculatedDates() }
    }
    @Published var selectedDeathRelationship: DeathRelationship? {
        didSet { updateAutoCalculatedDates() }
    }
    @Published var selectedGender: Gender? {
        didSet { updateAutoCalculatedDates() }
    }
    @Published var medicalDocument: PhotosPickerItem? {
        didSet { loadMedicalDocument() }
    }
    @Published var medicalDocumentURL: URL?
    
    
    @Published var alertMessage = ""
    @Published var showAlert = false
    @Published var isLoading = false
    
    var modelContext: ModelContext? // Hazlo opcional inicialmente

    // init principal (si lo necesitas para previews u otros casos)
    init(modelContext: ModelContext) {
       self.modelContext = modelContext
    }

    // init vacío para que @StateObject funcione sin parámetros iniciales
    init() {
       self.modelContext = nil // Se asignará en .onAppear
    }
    
    var shouldShowManualDatePicker: Bool {
        selectedLeaveType != .license || selectedLicenseSubtype == .exam
    }

    func updateAutoCalculatedDates() {
        guard selectedLeaveType == .license,
              let selectedLicenseSubtype,
              selectedLicenseSubtype != .exam else {
            return
        }
        
        endDate = DateCalculations.calculateEndDate(
            startDate: startDate,
            licenseSubtype: selectedLicenseSubtype,
            deathRelationship: selectedDeathRelationship,
            gender: selectedGender
        )
    }
    
    
    private func resetTypeSpecificFields() {
        selectedLicenseSubtype = nil
        selectedDeathRelationship = nil
        selectedGender = nil
        medicalDocument = nil
        medicalDocumentURL = nil
    }
    
    private func loadMedicalDocument() {
        Task {
            guard let medicalDocument else { return }
            do {
                let data = try await medicalDocument.loadTransferable(type: Data.self)
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("medical_\(UUID().uuidString).jpg")
                try data?.write(to: tempURL)
                medicalDocumentURL = tempURL
            } catch {
                showAlert(message: "Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    
    func validateForm() -> Bool {
        guard !employeeName.isEmpty else {
            showAlert(message: "Nombre del funcionario es requerido")
            return false
        }
        
        guard startDate <= endDate else {
            showAlert(message: "Fecha final debe ser después de la inicial")
            return false
        }
        
        switch selectedLeaveType {
        case .medical where medicalDocumentURL == nil:
            showAlert(message: "Comprobante médico es requerido")
            return false
            
        case .license where selectedLicenseSubtype == nil:
            showAlert(message: "Tipo de licencia es requerido")
            return false
            
        case .license where selectedLicenseSubtype == .mourning && selectedDeathRelationship == nil:
            showAlert(message: "Parentesco es requerido para luto")
            return false
            
        case .license where selectedLicenseSubtype == .birth && selectedGender == nil:
            showAlert(message: "Género es requerido para nacimiento")
            return false
            
        default:
            return true
        }
    }
    
    
    func submitLeaveRequest() async {
        guard let modelContext = modelContext else {
            print("Error: ModelContext no está asignado.")
            showAlert(message: "Error interno al guardar.")
            return
        }

        guard validateForm(), let selectedLeaveType else { return }
        
        isLoading = true
        
        let leave = LeaveRequest(
            employeeName: employeeName,
            startDate: startDate,
            endDate: endDate,
            type: selectedLeaveType,
            medicalDocumentURL: medicalDocumentURL?.absoluteString,
            licenseSubtype: selectedLicenseSubtype,
            deathRelationship: selectedDeathRelationship,
            gender: selectedGender
        )
        
        modelContext.insert(leave)
        
        do {
            try modelContext.save()
            resetForm()
        } catch {
            showAlert(message: "Error guardando: \(error.localizedDescription)")
        }
        
        isLoading = false
    }

    
    private func resetForm() {
        employeeName = ""
        startDate = Date()
        endDate = Date()
        selectedLeaveType = nil
        resetTypeSpecificFields()
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}


extension LeaveViewModel {
    var formTitle: String {
        selectedLeaveType?.rawValue ?? "Nueva solicitud"
    }
    
    var endDateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: endDate)
    }
    
    var isFormValid: Bool {
        !employeeName.isEmpty &&
        startDate <= endDate &&
        (selectedLeaveType != .medical || medicalDocumentURL != nil) &&
        (selectedLeaveType != .license || selectedLicenseSubtype != nil) &&
        (selectedLicenseSubtype != .mourning || selectedDeathRelationship != nil) &&
        (selectedLicenseSubtype != .birth || selectedGender != nil)
    }
}


