import Foundation

class EventoManager {
    static let shared = EventoManager()
    private let feriadoManager = FeriadoManager.shared
    
    private init() {}
    
    //Lógica Principal
    func obtenerEventosDeHoy(token: String? = nil) async -> [Evento] {
        var eventos: [Evento] = []
        
        //Feriados (siempre disponibles)
        eventos += obtenerFeriadosActuales()
        
        //Cumpleaños (solo con autenticación)
        if let token = token {
            eventos += await obtenerCumpleaniosActuales(token: token)
        }
        
        return eventos.sorted { $0.titulo < $1.titulo }
    }
    
    //Métodos Privados
    private func obtenerFeriadosActuales() -> [Evento] {
        return feriadoManager.obtenerFeriadosDeHoy().map {
            Evento(
                titulo: $0.nombre,
                icono: $0.icono,
                color: $0.color,
                tipo: "feriado",
                fecha: $0.fecha
            )
        }
    }
    
    private func obtenerCumpleaniosActuales(token: String) async -> [Evento] {
        let cumpleaneros: [User]
        
        do {
            // Intenta obtener datos reales
            cumpleaneros = try await UserService.shared.obtenerCumpleanerosHoy(token: token)
            
            #if DEBUG
            if cumpleaneros.isEmpty {
                print("🔵 No hay cumpleañeros reales. Usando datos mock para debug...")
                return generarEventosDeCumpleaniosMock()
            }
            #endif
        } catch {
            print("⚠️ Error al obtener cumpleañeros:", error.localizedDescription)
            #if DEBUG
            return generarEventosDeCumpleaniosMock() // Solo en desarrollo
            #else
            return [] // En producción retorna vacío
            #endif
        }
        
        return cumpleaneros.map { crearEventoDeCumpleanios(para: $0) }
    }
    
    //Helper para crear eventos
    private func crearEventoDeCumpleanios(para usuario: User) -> Evento {
        return Evento(
            titulo: "Cumpleaños de \(usuario.nombre)",
            icono: "🎂",
            color: .pink,
            tipo: "cumpleaños",
            fecha: usuario.fechaNacimiento
        )
    }
    
    //Datos Mock (solo para debug)
    private func generarEventosDeCumpleaniosMock() -> [Evento] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let hoy = formatter.string(from: Date())
        
        let mockUsers = [
            User(
                id: 99,
                nombre: "El Papu",
                apellido: "Developer",
                fechaNacimiento: hoy,
                correo: "papu@roshka.com"
            ),
            User(
                id: 100,
                nombre: "Usuario",
                apellido: "Demo",
                fechaNacimiento: hoy,
                correo: "demo@roshka.com"
            )
        ]
        
        return mockUsers.map { crearEventoDeCumpleanios(para: $0) }
    }
}
