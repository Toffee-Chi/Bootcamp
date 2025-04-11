import SwiftUI
import SwiftData
import PhotosUI
import Kingfisher

struct LeaveFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject public var viewModel: LeaveViewModel
    
//    init() {
//        let tempContainer = try! ModelContainer(for: LeaveRequest.self)
//        _viewModel = StateObject(wrappedValue: LeaveViewModel(modelContext: tempContainer.mainContext))
//    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Seccion comun
                Section {
                    TextField("Nombre del funcionario", text: $viewModel.employeeName)
                    
                    DatePicker("Fecha de inicio",
                               selection: $viewModel.startDate,
                               displayedComponents: .date)
                    .onChange(of: viewModel.startDate) {
                        _,_ in viewModel.updateAutoCalculatedDates()
                    }
                    
                    if viewModel.shouldShowManualDatePicker{
                        DatePicker("Fecha de fin",
                                   selection: $viewModel.endDate,
                                   in: viewModel.startDate...,
                                   displayedComponents: .date)
                    } else {
                        Text("Fecha de fin calculada: \(viewModel.endDateFormatted)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Picker para el tipo de permiso
                Section("Tipo de permiso") {
                    Picker("Seleccionar tipo", selection: $viewModel.selectedLeaveType) {
                        ForEach(LeaveType.allCases) { type in
                            Text(type.rawValue).tag(type as LeaveType?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: viewModel.selectedLeaveType) { _, _ in
                        viewModel.updateAutoCalculatedDates()
                    }
                }
                
                // acciones por tipo de permiso
                if viewModel.selectedLeaveType == .medical {
                    medicalDocumentSection
                }
                
                if viewModel.selectedLeaveType == .license {
                    licenseSubtypeSection
                    
                    if viewModel.selectedLicenseSubtype?.requiresRelationship == true {
                        relationshipPickerSection
                    }
                    
                    if viewModel.selectedLicenseSubtype?.requiresGender == true {
                        genderPickerSection
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.updateAutoCalculatedDates()
            }
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    submitButton
                }
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
        .navigationTitle(viewModel.formTitle)
    }
    
    
    private var medicalDocumentSection: some View {
        Section("Comprobante médico") {
            PhotosPicker(selection: $viewModel.medicalDocument,
                         matching: .images) {
                Label(
                    viewModel.medicalDocumentURL != nil ? "Documento adjuntado" : "Seleccionar documento",
                    systemImage: "doc.text"
                )
            }
            
            if let url = viewModel.medicalDocumentURL {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(8)
            }
        }
    }
    
    private var licenseSubtypeSection: some View {
        Section("Tipo de licencia") {
            Picker("Seleccionar subtipo", selection: $viewModel.selectedLicenseSubtype) {
                ForEach(LicenseSubtype.allCases) { subtype in
                    Text(subtype.rawValue).tag(subtype as LicenseSubtype?)
                }
            }
            .pickerStyle(.navigationLink)
            .onChange(of: viewModel.selectedLicenseSubtype) { _, _ in
                viewModel.updateAutoCalculatedDates()
            }
        }
    }
    
    private var relationshipPickerSection: some View {
        Section("Parentesco (Luto)") {
            Picker("Parentesco", selection: $viewModel.selectedDeathRelationship) {
                ForEach(DeathRelationship.allCases) { subtype in
                    Text(subtype.rawValue).tag(subtype as DeathRelationship?)
                }
            }
            .pickerStyle(.navigationLink)
            .onChange(of: viewModel.selectedLicenseSubtype) { _, _ in
                viewModel.updateAutoCalculatedDates()
            }
        }
    }
    
    private var genderPickerSection: some View {
        Section("Género (Nacimiento)") {
            Picker("Genereo", selection: $viewModel.selectedGender) {
                ForEach(Gender.allCases) { subtype in
                    Text(subtype.rawValue).tag(subtype as Gender?)
                }
            }
            .pickerStyle(.navigationLink)
            .onChange(of: viewModel.selectedLicenseSubtype) { _, _ in
                viewModel.updateAutoCalculatedDates()
            }
        }
    }
    
    
    private var submitButton: some View {
        Button("Enviar") {
            Task { await viewModel.submitLeaveRequest() }
        }
        .disabled(!viewModel.isFormValid)
    }
}

//#Preview {
//    LeaveFormView()
//        .modelContainer(for: LeaveRequest.self)
//}
