import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int? // si es nill, por default es la vista HomeView
    let tabs = [
        (icon: "ic_rest1", selectedIcon: "ic_rest1_filled", title: ""),
        (icon: "ic_calendar", selectedIcon: "ic_calendar_filled", title: ""),
        (icon: "ic_add_people", selectedIcon: "ic_add_people", title: ""),
        (icon: "ic_licence", selectedIcon: "ic_licences_filled", title: ""),
        (icon: "ic_birthday", selectedIcon: "ic_birthday_filled", title: "")

    ]
    
    var body: some View {
        HStack(spacing: 0) {
            // Solo los 4 tabs (sin Home)
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: { selectedTab = index }) {
                    VStack(spacing: 4) {
                        Image(selectedTab == index ? tabs[index].selectedIcon : tabs[index].icon)
                            .resizable()
                            .frame(width: 34, height: 34)
                        Text(tabs[index].title)
                            .font(.caption2)
                    }
                    .foregroundColor(selectedTab == index ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background(Color.white.shadow(color: .black.opacity(0.1), radius: 5, y: -3))
    }
}
struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(0)) //Ahora recibe el parámetro
            .previewDisplayName("Versión Final")
    }
}
