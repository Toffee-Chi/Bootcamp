import SwiftUI
enum LeaveType: String, CaseIterable, Codable, Identifiable {
    case vacation = "Vacaciones"
    case medical = "Reposo médico"
    case license = "Licencia"
    
    var id: String { rawValue }
    
    var hasSubtypes: Bool {
        self == .license
    }
    var hasAutoCalculatedEndDate: Bool {
            self == .license
        }
    
    var iconName: String {
        switch self {
        case .vacation:
            return "vacation"
        case .medical:
            return "medical"
        case .license:
            return ""
        }
    }
    
}

enum LicenseSubtype: String, CaseIterable, Codable, Identifiable {
    case exam = "Exámenes"
    case marriage = "Matrimonio"
    case mourning = "Luto"
    case birth = "Nacimiento"
    
    var id: String { rawValue }
    
    var requiresRelationship: Bool {
        self == .mourning
    }
    
    var requiresGender: Bool {
        self == .birth
    }
    
    var iconName: String {
            switch self {
            case .exam:
                return "exam"
            case .marriage:
                return "marriage"
            case .mourning:
                return "mourning"
            case .birth:
                return ""
            }
        }
}

enum DeathRelationship: String, CaseIterable, Codable, Identifiable {
    case parents = "Padre/Madre"
    case children = "Hijo/Hija"
    case siblings = "Hermano/Hermana"
    case grandparents = "Abuelo/Abuela"
    case other = "Otro Familiar"
    
    var id: String { rawValue }
}

enum Gender: String, CaseIterable, Codable, Identifiable {
    case male = "Masculino"
    case female = "Femenino"
    
    var iconName: String {
            switch self {
            case .male:
                return "male"
            case .female:
                return "female"
            }
        }
    
    var id: String { rawValue }
}

