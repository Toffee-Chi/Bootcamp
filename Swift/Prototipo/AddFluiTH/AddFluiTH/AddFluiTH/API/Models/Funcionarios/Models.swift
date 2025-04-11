import Foundation

enum Estado {
    case verde //vacaciones
    case amarillo //licencias
    case rojo //reposo
}
struct Funcionario: Identifiable {
    let id = UUID()
    let nombre: String
    let estado: Estado
}
struct Empresa: Identifiable {
    let id = UUID()
    let nombre: String
    let funcionarios: [Funcionario]
}
