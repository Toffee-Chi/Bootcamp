import Foundation

struct ApprovedVacation: Identifiable {
    var id: UUID
    var nombre: String
    var apellido: String
    var fechaInicio: String
    var fechaFin: String

    static func mockup() -> ApprovedVacation {
        ApprovedVacation(id: UUID(), nombre: "María", apellido: "Gómez", fechaInicio: "2025-04-15", fechaFin: "2025-04-20")
    }
}
