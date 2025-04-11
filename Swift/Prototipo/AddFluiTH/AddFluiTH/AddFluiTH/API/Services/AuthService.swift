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
        
        print("🔵 [Auth] Enviando solicitud a:", url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        let responseString = String(data: data, encoding: .utf8) ?? ""
        print("✅ [Auth] Respuesta HTTP:", httpResponse.statusCode)
        
        switch httpResponse.statusCode {
        case 200...299:
            let token = responseString.trimmingCharacters(in: .whitespacesAndNewlines)
            //Validación del token
            guard !token.isEmpty else {
                print("❌ [Auth] Token vacío recibido")
                throw AuthError.invalidResponse
            }
            
            //Debug: Mostrar info del token
            print("🔍 Token recibido:")
            print("- Longitud: \(token.count) caracteres")
            print("- Empieza con: \(token.prefix(1))...\(token.suffix(1))")
            
            //Intento de guardado con verificación
            if KeychainHelper.saveString(key: "authToken", value: token) {
                print("🔐 [Auth] Intento de guardado en Keychain exitoso")
                //Verificación inmediata
                if let savedToken = KeychainHelper.loadString(key: "authToken") {
                    print("✅ [Auth] Token verificado en Keychain (primeros 10 chars):", savedToken.prefix(10), "...")
                    
                    // Verificación de integridad
                    if savedToken == token {
                        print("🔄 [Auth] Token coincide exactamente con el recibido")
                        return LoginResponse(token: token)
                    } else {
                        print("❌ [Auth] El token guardado NO coincide con el original")
                        throw AuthError.keychainError
                    }
                } else {
                    print("❌ [Auth] No se pudo leer el token después de guardarlo")
                    throw AuthError.keychainError
                }
            } else {
                print("❌ [Auth] Falló el guardado inicial en Keychain")
                throw AuthError.keychainError
            }
            
        case 401:
            print("❌ [Auth] Error 401: Credenciales inválidas")
            throw URLError(.userAuthenticationRequired)
            
        default:
            if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                print("❌ [Auth] Error del servidor:", errorResponse.message)
                throw AuthError.apiError(message: errorResponse.message)
            }
            throw AuthError.invalidResponse
        }
    }
    
    //verificar el token guardado
    static func verifyStoredToken() -> Bool {
        if let savedToken = KeychainHelper.loadString(key: "authToken") {
            print("🔍 Token almacenado:", savedToken.prefix(10), "...")
            return !savedToken.isEmpty
        }
        return false
    }

}
