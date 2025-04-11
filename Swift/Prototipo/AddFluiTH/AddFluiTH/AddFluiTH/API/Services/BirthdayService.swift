import Foundation

class BirthdayService {
    static let shared = BirthdayService()
    private let baseURL = "https://bootcamp.iservers.roshka.com/api/vacaciones/listarusuarios"
    
    func obtenerCumpleanieros(fecha: Date) async throws -> [Birthday] {
        //Obtener token desde Keychain
        guard let token = KeychainHelper.loadString(key: "authToken") else {
            print("❌ [Birthday] No hay token en Keychain")
            throw AuthError.keychainError
        }
        
        //Formatear fecha
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fechaString = formatter.string(from: fecha)
        
        //Crear request con token
        guard let url = URL(string: baseURL) else {
            print("❌ [Birthday] URL inválida")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") //Token dinámico
        
        print("🔵 [Birthday] Enviando solicitud a:", url.absoluteString)
        
        //Hacer la petición con async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //Validar respuesta
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ [Birthday] Respuesta HTTP:", httpResponse.statusCode)
        
        switch httpResponse.statusCode {
        case 200...299:
            do {
                let cumpleanieros = try JSONDecoder().decode([Birthday].self, from: data)
                print("🎉 [Birthday] Cumpleañeros obtenidos:", cumpleanieros.count)
                return cumpleanieros
            } catch {
                print("❌ [Birthday] Error al decodificar JSON:", error)
                throw error
            }
        case 401:
            print("❌ [Birthday] Error 401: Token inválido/expirado")
            throw AuthError.apiError(message: "Token inválido")
        default:
            if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                print("❌ [Birthday] Error del servidor:", errorResponse.message)
                throw AuthError.apiError(message: errorResponse.message)
            }
            throw AuthError.invalidResponse
        }
    }
}
