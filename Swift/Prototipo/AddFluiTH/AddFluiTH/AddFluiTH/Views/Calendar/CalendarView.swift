import SwiftUI

struct CalendarView: View {
    @State var currentDate: Date = Date()
    let events: [CalendarEvent]

    var onDateSelected: ((Date) -> Void)? = nil

    private let calendar = Calendar.current


    private var daysInMonth: [Date] {
        guard
            let range = calendar.range(of: .day, in: .month, for: currentDate),
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
        else { return [] }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
        }
    }


    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }

    var body: some View {
        VStack {

            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
                Spacer()
                Text(monthYearFormatter.string(from: currentDate))
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
            }
            .padding(.horizontal)



            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                // Nombres abreviados de días (puedes adaptarlo al idioma deseado)
                ForEach(["L", "M", "X", "J", "V", "S", "D"], id: \.self) { dayName in
                    Text(dayName)
                        .font(.subheadline)
                        .bold()
                }
                

                ForEach(daysInMonth, id: \.self) { day in
                    DayView(date: day,
                            events: eventsForDate(day),
                            isToday: calendar.isDateInToday(day))
                        .onTapGesture {

                            onDateSelected?(day)
                        }
                }
            }
            .padding(.horizontal)
        }
    }


    private func nextMonth() {
        if let next = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = next
        }
    }


    private func previousMonth() {
        if let prev = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = prev
        }
    }


    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
