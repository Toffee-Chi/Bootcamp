import Foundation
// Autenticación
struct LoginRequest: Codable {
    let usuario: String
    let password: String
}
// Respuesta de login exitoso
struct LoginResponse: Codable {
    let token: String
}
struct User: Codable {
    let id: Int
    let nombre: String
    let apellido: String
    let fechaNacimiento: String
    let correo: String
    
    // Computed property para compatibilidad
    var name: String {
        return "\(nombre) \(apellido)"
    }
    
    var email: String {
        return correo
    }
    
    var esCumpleaniosHoy: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let nacimiento = formatter.date(from: fechaNacimiento) else { return false }
        
        let calendar = Calendar.current
        let hoy = Date()
        
        return calendar.component(.month, from: nacimiento) == calendar.component(.month, from: hoy) &&
               calendar.component(.day, from: nacimiento) == calendar.component(.day, from: hoy)
    }
}

// Error estándar de la API
struct APIErrorResponse: Codable {
    let message: String
}

// Errores para mostrar si es que hay
enum AuthError: Error, LocalizedError {
    case apiError(message: String)
    case keychainError
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .apiError(let message):
            return message
        case .keychainError:
            return "Error al guardar las credenciales"
        case .invalidResponse:
            return "Respuesta inválida del servidor"
        }
    }
}
