import Foundation

class UserService {
    static let shared = UserService()
    private let baseURL = "https://bootcamp.iservers.roshka.com/api"
    
    //Función optimizada para obtener todos los usuarios
    func obtenerUsuarios(token: String) async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/vacaciones/listarusuarios") else {
            print("❌ Error: URL inválida")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("🔵 [UserService] Obteniendo todos los usuarios...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Error: Respuesta inválida del servidor")
            throw URLError(.badServerResponse)
        }
        
        print("✅ Status code:", httpResponse.statusCode)
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ Error: Status code no exitoso")
            throw URLError(.badServerResponse)
        }
        
        do {
            let usuarios = try JSONDecoder().decode([User].self, from: data)
            print("🟢 Usuarios recibidos correctamente. Total:", usuarios.count)
            return usuarios
        } catch {
            print("❌ Error decodificando usuarios:", error.localizedDescription)
            throw error
        }
    }
    
    //Función específica para cumpleañeros del día
    func obtenerCumpleanerosHoy(token: String) async throws -> [User] {
        print("🔵 [UserService] Buscando cumpleañeros del día...")
        
        do {
            // Obtener todos los usuarios
            let usuarios = try await obtenerUsuarios(token: token)
            
            // Filtrar por cumpleaños hoy
            let cumpleaneros = usuarios.filter { $0.esCumpleaniosHoy }
            
            //Mostrar resultados
            print("🎂 Cumpleañeros encontrados hoy:", cumpleaneros.count)
            cumpleaneros.forEach {
                print(" - \($0.nombre) (\($0.fechaNacimiento))")
            }
            
            return cumpleaneros
            
        } catch {
            print("❌ Error al obtener cumpleañeros:", error.localizedDescription)
            throw error
        }
    }
    
    //Función de prueba para desarrollo (opcional)
    func mockCumpleaneros() -> [User] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let hoy = formatter.string(from: Date())
        
        return [
            User(
                id: 1,
                nombre: "Usuario",
                apellido: "Prueba",
                fechaNacimiento: hoy,
                correo: "test@example.com"
            )
        ]
    }
}
