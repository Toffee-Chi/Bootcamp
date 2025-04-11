import SwiftUI

struct CalendarViewBirthday: View {
    @StateObject private var viewModel = CalendarViewBirthdayModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Cumpleaños")
                    .font(.title)
                    .bold()
                    .padding(.top)

                MonthCalendarBirthdayView(selectedDate: $viewModel.selectedDate)

                Text("Hoy")
                    .font(.headline)
                    .padding(.top)

                // Mostrar loading/error o la lista
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    BirthdayListView(birthdays: viewModel.birthdays)
                }

                Spacer()
            }
            .onChange(of: viewModel.selectedDate) { _ in
                viewModel.updateDate(to: viewModel.selectedDate)
            }
        }
    }
}

