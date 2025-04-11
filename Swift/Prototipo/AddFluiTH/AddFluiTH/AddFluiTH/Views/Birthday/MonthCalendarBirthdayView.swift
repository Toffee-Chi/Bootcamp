import SwiftUI

struct MonthCalendarBirthdayView: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker(
            "Seleccioná una fecha",
            selection: $selectedDate,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
        .accentColor(.blue)
        .padding()
    }
}

