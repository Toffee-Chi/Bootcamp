import SwiftUI

struct Rest: View {
    @State private var selectedDate: Date? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Eventos")
                    .foregroundColor(Color(red: 6/255, green: 65/255, blue: 137/255))
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)

                CalendarView(events: [], onDateSelected: { date in
                    selectedDate = date
                })
                .padding(.horizontal)

                if let date = selectedDate {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hoy")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color(red: 6/255, green: 65/255, blue: 137/255))
                            .padding(.horizontal)

                        if isProjectDay(date) {
                            eventCard(title: "Día del proyecto", icon: "calendar.badge.clock")
                        }

                        if isFarraDay(date) {
                            eventCard(title: "Farra del Día del Trabajador", icon: "party.popper")
                        }
                    }
                }

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }

 
    @ViewBuilder
    func eventCard(title: String, icon: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Spacer()

            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color(red: 6/255, green: 65/255, blue: 137/255))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }


    func isProjectDay(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        let components = Calendar.current.dateComponents([.day, .month], from: date)
        return components.day == 11 && components.month == 4
    }

    func isFarraDay(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        let components = Calendar.current.dateComponents([.day, .month], from: date)
        return components.day == 2 && components.month == 5
    }
}

struct Rest_Previews: PreviewProvider {
    static var previews: some View {
        Rest()
    }
}

