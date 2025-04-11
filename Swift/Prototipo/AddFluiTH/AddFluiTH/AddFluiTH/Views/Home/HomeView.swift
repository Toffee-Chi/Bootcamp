import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Int? = nil
    @State private var activeView: HamburgerMenu.ActiveView? = nil
    let onLogout: () -> Void
    
    // Estados para manejar eventos globales
    @State private var showBirthdayAlert = false
    @State private var birthdayMessage = ""
    @State private var debugMessages = [String]()
    
    var body: some View {
        ZStack {
            // Contenido Principal
            if selectedTab == nil && activeView == nil {
                HomeContentView()
                    .onAppear {
                        Task {
                            await checkBirthdays()
                        }
                    }
            }
            else if let selectedTab = selectedTab {
                switch selectedTab {
                case 0: Rest()
                case 1: WebVacation()
                case 2: LeaveListView()
                case 3: Licenses()
                case 4: BirthDay()
                default: EmptyView()
                }
            }
            else if let activeView = activeView {
                switch activeView {
                case .funcionarios:
                    Text("Vista temporal de Funcionarios").bold()
                case .logout: Color.clear.task { onLogout() }
                case .help: Help()
                default: EmptyView()
                }
            }
            
            // UI común
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
            
            // Debug View (solo para desarrollo)
            #if DEBUG
            debugInfoView
            #endif
        }
        .alert("¡Cumpleaños!", isPresented: $showBirthdayAlert) {
            Button("¡Felicitar!") {
                // Acción opcional al presionar
            }
            Button("Cerrar", role: .cancel) {}
        } message: {
            Text(birthdayMessage)
        }
    }
    
    private func checkBirthdays() async {
        addDebugMessage("🔵 [1/4] Iniciando verificación de cumpleaños...")
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            addDebugMessage("❌ [2/4] Fallo crítico: No hay token en UserDefaults")
            addDebugMessage("ℹ️ Keys en UserDefaults: \(UserDefaults.standard.dictionaryRepresentation().keys)")
            return
        }
        
        addDebugMessage("🔵 [2/4] Token encontrado: \(token.prefix(10))...")
        
        do {
            addDebugMessage("🔵 [3/4] Llamando a UserService...")
            let cumpleaneros = try await UserService.shared.obtenerCumpleanerosHoy(token: token)
            
            addDebugMessage("✅ [4/4] Respuesta recibida. Usuarios: \(cumpleaneros.count)")
            
            if !cumpleaneros.isEmpty {
                let names = cumpleaneros.map { $0.name }.joined(separator: ", ")
                birthdayMessage = "¡Hoy cumple años: \(names)! 🎉"
                showBirthdayAlert = true
                addDebugMessage("🎉 Cumpleañeros: \(names)")
            } else {
                addDebugMessage("ℹ️ No hay cumpleañeros hoy")
            }
            
        } catch {
            addDebugMessage("❌ [4/4] ERROR: \(error.localizedDescription)")
            addDebugMessage("ℹ️ Tipo de error: \(type(of: error))")
        }
    }
    // Función auxiliar para debug
    private func addDebugMessage(_ message: String) {
        print(message)
        debugMessages.append(message)
        if debugMessages.count > 10 {
            debugMessages.removeFirst()
        }
    }
    
    // Vista de debug (solo en modo desarrollo)
    #if DEBUG
    private var debugInfoView: some View {
        VStack {
            if !debugMessages.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(debugMessages, id: \.self) { message in
                            Text(message)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(message.contains("❌") ? .red : .green)
                        }
                    }
                    .padding(8)
                }
                .frame(width: 300, height: 150)
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
                .position(x: UIScreen.main.bounds.width - 160, y: 120)
            }
        }
    }
    #endif
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(onLogout: {})
    }
}
