import Foundation

import Foundation

class AuthService {
    static let shared = AuthService()
    private let baseURL = "https://bootcamp.iservers.roshka.com/api/api/auth/login"
    
    func login(usuario: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(usuario: usuario, password: password)
        request.httpBody = try JSONEncoder().encode(body)
        
        print("Enviando solicitud a:", url.absoluteString)
        print("Body:", String(data: request.httpBody!, encoding: .utf8) ?? "")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let responseString = String(data: data, encoding: .utf8) ?? ""
        print("Respuesta HTTP:", httpResponse.statusCode)
        print("Contenido:", responseString)
        
        switch httpResponse.statusCode {
        case 200...299:
            // Opción 1: Si la API devuelve SOLO el token como string
            return LoginResponse(token: responseString)            
        case 401:
            throw URLError(.userAuthenticationRequired)
            
        default:
            if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw AuthError.apiError(message: errorResponse.message)
            }
            throw URLError(.badServerResponse)
        }
    }
}
struct APIErrorResponse: Codable {
    let message: String
}

enum AuthError: Error {
    case apiError(message: String)
}
