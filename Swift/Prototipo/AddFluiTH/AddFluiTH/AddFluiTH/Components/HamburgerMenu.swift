import SwiftUI

struct HamburgerMenu: View {
    // Estados para controlar el menú y la navegación
    @State private var isMenuOpen = false
    @Binding var selectedTab: Int?
    @Binding var activeView: ActiveView?
    
    // Opciones del menú
    let menuOptions = ["Funcionarios", "Menú", "Cerrar Sesión", "Ayuda"]
    
    // Enum para manejar las vistas
    enum ActiveView {
        case funcionarios
        case menu
        case logout
        case help
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Botón hamburguesa
            Button(action: {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                    isMenuOpen.toggle()
                }
            }) {
                Image("ic_menu_blue")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 20)
                    .padding(.top, 50)
            }
            
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isMenuOpen = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(0)
            }
            
            // Menú desplegable
            if isMenuOpen {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(menuOptions, id: \.self) { option in
                        Button(action: {
                            withAnimation {
                                isMenuOpen = false
                            }
                            handleMenuSelection(option)
                        }) {
                            HStack {
                                Image(systemName: iconForOption(option))
                                    .foregroundColor(.white)
                                    .frame(width: 25)
                                Text(option)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .contentShape(Rectangle())
                        }
                    }
                }
                .frame(width: 250)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.trailing, 20)
                .padding(.top, 110)
                .transition(.move(edge: .trailing))
                .zIndex(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    // Función para manejar la selección del menú
    private func handleMenuSelection(_ option: String) {
        switch option {
        case "Funcionarios":
            activeView = .funcionarios
        case "Menú":
            selectedTab = nil
            activeView = nil
        case "Cerrar Sesión":
            activeView = .logout
        case "Ayuda":
            activeView = .help
        default:
            break
        }
    }
    
    // Función para asignar iconos
    private func iconForOption(_ option: String) -> String {
        switch option {
        case "Funcionarios": return "person.3.fill"
        case "Menú": return "house.fill"
        case "Cerrar Sesión": return "power"
        case "Ayuda": return "questionmark.circle.fill"
        default: return "circle.fill"
        }
    }
}

struct HamburgerMenu_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTab: Int? = nil
        @State var activeView: HamburgerMenu.ActiveView? = nil
        
        return HamburgerMenu(selectedTab: $selectedTab, activeView: $activeView)
            .previewDisplayName("Menú Hamburguesa")
            .background(Color.gray.opacity(0.1))
    }
}
