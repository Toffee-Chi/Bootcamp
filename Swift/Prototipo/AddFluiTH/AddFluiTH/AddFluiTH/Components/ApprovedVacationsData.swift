import Foundation

class ApprovedVacationsData {
    func fetchApprovedVacations(completion: @escaping ([ApprovedVacation]?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion([
                ApprovedVacation.mockup(),
                ApprovedVacation(id: UUID(), nombre: "Carlos", apellido: "Ramírez", fechaInicio: "2025-05-01", fechaFin: "2025-05-10")
            ])
        }
    }
}

