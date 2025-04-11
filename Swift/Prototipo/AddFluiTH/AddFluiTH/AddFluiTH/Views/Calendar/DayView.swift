import SwiftUI

struct DayView: View {
    let date: Date
    let events: [CalendarEvent]
    let isToday: Bool

    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    var body: some View {
        VStack(spacing: 4) {
            Text(dayFormatter.string(from: date))
                .font(.subheadline)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .white : .primary)
                .padding(10)
                .background(isToday
                            ? Color(red: 6/255, green: 65/255, blue: 137/255)
                            : Color.clear)
                .cornerRadius(0)
                .overlay(
                    Rectangle()
                        .stroke(isToday
                                ? Color(red: 6/255, green: 65/255, blue: 137/255)
                                : Color.clear,
                                lineWidth: 2)
                )

            // Punto azul si es hoy
            if isToday {
                Rectangle()
                    .fill(Color(red: 6/255, green: 65/255, blue: 137/255))
                    .frame(width: 6, height: 6)
            }

            // Punto rojo si es 11 de abril
            if isProjectDay(date: date) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 6, height: 6)
            }

            // Iconos por tipo de evento
            ForEach(events) { event in
                switch event.type {
                case .vacaciones:
                    Image(systemName: "airplane")
                        .font(.caption2)
                case .cumpleanios:
                    Image(systemName: "gift.fill")
                        .font(.caption2)
                case .licencia:
                    Image(systemName: "person.fill.questionmark")
                        .font(.caption2)
                case .reposo:
                    Image(systemName: "bandage.fill")
                        .font(.caption2)
                }
            }
        }
        .frame(minHeight: 50)
    }

    private func isProjectDay(date: Date) -> Bool {
        let components = Calendar.current.dateComponents([.day, .month], from: date)
        return components.day == 11 && components.month == 4
    }
}
