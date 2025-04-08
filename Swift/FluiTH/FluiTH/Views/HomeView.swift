import SwiftUI

struct HomeView: View {
    // Estados para controlar navegación
    @State private var selectedTab: Int? = nil
    @State private var activeView: HamburgerMenu.ActiveView? = nil
    @State private var showAprovedView = false
    let onLogout: () -> Void
    
    // Feriados de hoy
    @State private var feriadosHoy: [Feriado] = []
    
    // Variable para la fecha formateada
    private var fechaActual: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM 'de' yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                //Contenido Principal
                if selectedTab == nil && activeView == nil {
                    VStack(spacing: 40) {
                        // Encabezado
                        HStack(alignment: .firstTextBaseline, spacing: 0) {
                            Text("¡Bien")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text("venido")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                            Text("!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .offset(y: 60)
                        
                        // Contenido específico con fecha actual
                        Text("Hoy, \(fechaActual)")
                            .foregroundColor(.gray)
                            .offset(y: 25)
                        
                        // Botones flotantes
                        FloatingAprovedButton()
                            .offset(y: 150)
                        
                        FloatingPendingButton()
                            .offset(y: -120)
                            .offset(x: 100)
                        
                        FloatingResumeList()
                            .offset(x: 105)
                        
                        // Lista de feriados
                        if !feriadosHoy.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Feriados Hoy")
                                    .font(.headline)
                                    .padding(.leading, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(feriadosHoy) { feriado in
                                            HStack {
                                                Text(feriado.icono)
                                                    .font(.title)
                                                Text(feriado.nombre)
                                                    .font(.subheadline)
                                            }
                                            .padding(10)
                                            .background(feriado.color.opacity(0.2))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(feriado.color, lineWidth: 1)
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            .offset(y: -125)
                        } else {
                            Text("No hay feriados hoy")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .offset(y: -125)
                        }
                    }
                    .onAppear {
                        feriadosHoy = FeriadoManager.shared.obtenerFeriadosDeHoy()
                    }
                }
                
                
                
                else if selectedTab != nil {
                    switch selectedTab {
                    case 0: Rest()
                    case 1: WebVacation()
                    case 2: Licenses()
                    case 3: BirthDay()
                    default: EmptyView()
                    }
                }
                else if let activeView = activeView {
                    switch activeView {
                    case .employeesAdd:
                        EmployeesAdd()
                    case .menu:
                        EmptyView()
                    case .logout:
                        Color.clear
                            .task { onLogout() }
                    case .help:
                        Help()
                    }
                }
                
                if activeView == nil {
                    VStack {
                        Spacer()
                        CustomTabBar(selectedTab: $selectedTab)
                            .frame(height: 60)
                    }
                }
                HamburgerMenu(
                    selectedTab: $selectedTab,
                    activeView: $activeView
                )
                .offset(x: 0, y: -42)
                .zIndex(1)
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "AprovedView":
                    AprovedView()
                case "PendingView":
                    PendingView()
                default:
                    EmptyView()
                }
            }
        }
    }
}
// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(onLogout: {})
    }
}
