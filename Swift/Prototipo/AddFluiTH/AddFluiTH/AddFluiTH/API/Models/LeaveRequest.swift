import SwiftData
import Foundation

@Model
final class LeaveRequest {
    // para todos
    var employeeName: String
    var startDate: Date
    var endDate: Date
    var type: LeaveType
    var createdAt: Date = Date()
    
    var medicalDocumentURL: String? // para la imagen del reposo medico
    
    // License specific
    var licenseSubtype: LicenseSubtype? // para el tipo de licencia
    var deathRelationship: DeathRelationship? // solo para fallecimiento
    var gender: Gender? // solo para nacimiento
    
    init(
        employeeName: String,
        startDate: Date,
        endDate: Date,
        type: LeaveType,
        medicalDocumentURL: String? = nil,
        licenseSubtype: LicenseSubtype? = nil,
        deathRelationship: DeathRelationship? = nil,
        gender: Gender? = nil
    ) {
        self.employeeName = employeeName
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        
        // validacion para los tipos
        switch type {
        case .medical:
            self.medicalDocumentURL = medicalDocumentURL
        case .license:
            self.licenseSubtype = licenseSubtype
            self.deathRelationship = licenseSubtype == .mourning ? deathRelationship : nil
            self.gender = licenseSubtype == .birth ? gender : nil
        case .vacation:
            break
        }
    }
}

