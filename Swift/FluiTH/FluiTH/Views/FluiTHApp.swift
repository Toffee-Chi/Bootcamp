import SwiftUI
@main
struct FluiTHApp: App {
    @State private var isLoginSuccessful = false
    @State private var showLogoutAlert = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Login(isLoginSuccessful: $isLoginSuccessful)
                    .navigationDestination(isPresented: $isLoginSuccessful) {
                        HomeView(onLogout: {
                            
                            isLoginSuccessful = false
                        })
                        .navigationBarBackButtonHidden(true)
                    }
            }
            .alert("Sesión cerrada", isPresented: $showLogoutAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
