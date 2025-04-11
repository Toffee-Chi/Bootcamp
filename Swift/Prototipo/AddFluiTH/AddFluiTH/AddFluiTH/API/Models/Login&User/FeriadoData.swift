import SwiftUI
// Modelo para feriados
struct Feriado: Identifiable {
    let id = UUID() // Identificador único generado automáticamente
    let fecha: String  // Formato ISO "YYYY-MM-DD"
    let nombre: String
    let icono: String
    let color: Color
}

//Gestiona la lista de feriados
class FeriadoManager {
    static let shared = FeriadoManager()
    
    private init() {}
    
    private let todosFeriados: [Feriado] = [
        // 2025
        Feriado(fecha: "2025-01-01", nombre: "Año Nuevo", icono: "🎉", color: .red),
        Feriado(fecha: "2025-03-03", nombre: "Día de los Héroes", icono: "🎖️", color: .blue),
        Feriado(fecha: "2025-04-08", nombre: "Hola Papu", icono: "🔥", color: .brown),
        Feriado(fecha: "2025-04-09", nombre: "miercoles papu", icono: "🦖", color: .green),
        Feriado(fecha: "2025-04-10", nombre: "jueves papu", icono: "🦎", color: .orange),
        Feriado(fecha: "2025-04-11", nombre: "Dia Proyecto", icono: "👑", color: .yellow),
        Feriado(fecha: "2025-04-17", nombre: "Jueves Santo", icono: "✝️", color: .purple),
        Feriado(fecha: "2025-04-18", nombre: "Viernes Santo", icono: "✝️", color: .purple),
        Feriado(fecha: "2025-05-01", nombre: "Día del Trabajador", icono: "👷", color: .green),
        Feriado(fecha: "2025-05-14", nombre: "Día de la Independencia", icono: "🇵🇾", color: .red),
        Feriado(fecha: "2025-05-15", nombre: "Día de la Independencia", icono: "🇵🇾", color: .red),
        Feriado(fecha: "2025-06-16", nombre: "Día de la Paz del Chaco", icono: "🕊️", color: .blue),
        Feriado(fecha: "2025-08-15", nombre: "Fundación de Asunción", icono: "🏙️", color: .orange),
        Feriado(fecha: "2025-09-29", nombre: "Victoria de Boquerón", icono: "🎖️", color: .blue),
        Feriado(fecha: "2025-12-08", nombre: "Día de la Virgen de Caacupé", icono: "⛪", color: .purple),
        Feriado(fecha: "2025-12-25", nombre: "Navidad", icono: "🎄", color: .green),
        
        // 2026
        Feriado(fecha: "2026-01-01", nombre: "Año Nuevo", icono: "🎉", color: .red),
        Feriado(fecha: "2026-03-01", nombre: "Día de los Héroes", icono: "🎖️", color: .blue),
        Feriado(fecha: "2026-04-17", nombre: "Jueves Santo", icono: "✝️", color: .purple),
        Feriado(fecha: "2026-04-18", nombre: "Viernes Santo", icono: "✝️", color: .purple),
        Feriado(fecha: "2026-05-01", nombre: "Día del Trabajador", icono: "👷", color: .green),
        Feriado(fecha: "2026-05-14", nombre: "Día de la Independencia", icono: "🇵🇾", color: .red),
        Feriado(fecha: "2026-05-15", nombre: "Día de la Independencia", icono: "🇵🇾", color: .red),
        Feriado(fecha: "2026-06-12", nombre: "Día de la Paz del Chaco", icono: "🕊️", color: .blue),
        Feriado(fecha: "2026-08-15", nombre: "Fundación de Asunción", icono: "🏙️", color: .orange),
        Feriado(fecha: "2026-09-29", nombre: "Victoria de Boquerón", icono: "🎖️", color: .blue),
        Feriado(fecha: "2026-12-08", nombre: "Día de la Virgen de Caacupé", icono: "⛪", color: .purple),
        Feriado(fecha: "2026-12-25", nombre: "Navidad", icono: "🎄", color: .green)
    ]
    // Filtra feriados que coincidan con la fecha actual
    func obtenerFeriadosDeHoy() -> [Feriado] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let hoy = formatter.string(from: Date())
        
        return todosFeriados.filter { $0.fecha == hoy }
    }
}
