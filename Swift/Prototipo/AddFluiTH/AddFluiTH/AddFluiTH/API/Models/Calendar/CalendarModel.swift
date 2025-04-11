import Foundation

enum CalendarEventType {
    case vacaciones
    case cumpleanios
    case licencia
    case reposo
}

struct CalendarEvent: Identifiable, Hashable {
    let id: UUID = UUID()
    let date: Date
    let type: CalendarEventType
    let title: String
}
