import SwiftUI

struct MainContainerView: View {
    let onLogout: () -> Void
    @State private var selectedTab: Int? = nil
    @State private var activeView: HamburgerMenu.ActiveView? = nil

    var body: some View {
        ZStack(alignment: .bottom) {

            // Contenido principal basado en la navegación
            Group {
                if selectedTab == nil && activeView == nil {
                    HomeContentView()
                } else if let selectedTab = selectedTab {
                    switch selectedTab {
                    case 0:
                        WebVacation()
                    case 1:
                        Rest()
                    case 2:
                        LeaveListView()
                    case 3:
                        Licenses()
                    case 4:
                        BirthDay()
                    default:
                        EmptyView()
                    }
                } else if let activeView = activeView {
                    switch activeView {
                    case .funcionarios:
                        Funcionarios()
                    case .logout:
                        Color.clear.task { onLogout() }
                    case .help:
                        Help()
                    default:
                        EmptyView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // TabBar fijo en la parte inferior
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
                .zIndex(2)

            // Menú hamburguesa (arriba)
            HamburgerMenu(
                selectedTab: $selectedTab,
                activeView: $activeView
            )
            .offset(x: 0, y: -42)
            .zIndex(3)
        }
        .navigationDestination(for: String.self) { destination in
            switch destination {
            case "AprovedView": AprovedView()
            case "PendingView": PendingVacationsScreen()
            default: EmptyView()
            }
        }
    }
}
