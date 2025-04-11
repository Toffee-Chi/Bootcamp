import SwiftUI

struct BirthDay: View {
    @State private var events: [CalendarEvent] = []
    @State private var showAddEventSheet: Bool = false
    @State private var selectedDate: Date? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Cumpleaños")
                    .foregroundColor(Color(red: 6/255, green: 65/255, blue: 137/255))


                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                CalendarView(events: events, onDateSelected: { date in
                    selectedDate = date
                    showAddEventSheet = true
                })
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}


struct BirthDay_Previews: PreviewProvider {
    static var previews: some View {
        BirthDay()
    }
}
