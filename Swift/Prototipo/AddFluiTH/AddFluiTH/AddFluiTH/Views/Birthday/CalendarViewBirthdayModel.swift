import Foundation
import Combine

class CalendarViewBirthdayModel: ObservableObject {
    @Published var birthdays: [Birthday] = []
    @Published var selectedDate: Date = Date()
    @Published var isLoading = false
    @Published var errorMessage: String?

    //el init  no bloquea el hilo principal
    init() {
        Task { await fetchBirthdays(for: selectedDate) }
    }

    //función async
    func fetchBirthdays(for date: Date) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cumpleanieros = try await BirthdayService.shared.obtenerCumpleanieros(fecha: date)
            DispatchQueue.main.async { [weak self] in
                self?.birthdays = cumpleanieros
                self?.isLoading = false
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = error.localizedDescription
                self?.isLoading = false
            }
        }
    }

    //Función para actualizar fecha (llama a la versión async)
    func updateDate(to newDate: Date) {
        Task { await fetchBirthdays(for: newDate) }
    }
}
