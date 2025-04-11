import Foundation
struct PendingVacation: Codable, Identifiable {
    var id: UUID { UUID() }
    var nombre: String
    var apellido: String
    var fechaInicio: String
    var fechaFin: String
    
    static func mockup() -> PendingVacation {
        .init(
            nombre: "Juan",
            apellido: "Gonzalez",
            fechaInicio: "12 Dic",
            fechaFin: "06 Ene")
        
    }
}


class PendingVacationsData {
    func fetchPendingVacations(completion: @escaping ([PendingVacation]?) -> Void) {
        if let url = Bundle.main.url(forResource: "vacations", withExtension: "json") {
            do {
                // Datos del archivo .json
                let data = try Data(contentsOf: url)
                
                // Decodificacion de los datos
                let vacations = try JSONDecoder().decode([PendingVacation].self, from: data)
                completion(vacations)
            } catch {
                print("Error al cargar o decodificar el archivo JSON: \(error)")
                completion(nil)
            }
        } else {
            print("No se encontró el archivo JSON.")
            completion(nil)
        }
    }
}

