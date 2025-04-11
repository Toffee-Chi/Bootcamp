import Foundation
//Manager centralizado para peticiones API con autenticación
class APIManager {
    static let shared = APIManager()
    //URL base de la API
    private let baseURL = "https://bootcamp.iservers.roshka.com/api/"
    
    private init() {} //Prevenir inicialización externa
    //Método Principal
    //Ejecuta peticiones API genéricas con autenticación
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        
        //Construcción de URL
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        //Configuración del Request
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Añadir token de autenticación si existe
        if let token = KeychainHelper.loadString(key: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = body
        let (data, response) = try await URLSession.shared.data(for: request)
        //Validar respuesta HTTP
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("🔴 Error decodificando: \(error)")
            throw error
        }
    }
}
