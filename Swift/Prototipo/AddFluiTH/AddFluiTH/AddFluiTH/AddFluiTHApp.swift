// En AddFluiTHApp.swift
import SwiftUI
import SwiftData // Asegúrate de importar SwiftData

@main
struct FluiTHApp: App {
    @State private var isLoginSuccessful = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !isLoginSuccessful {
                    LoginView(isLoginSuccessful: $isLoginSuccessful)
                } else {
                    MainContainerView(onLogout: {
                        isLoginSuccessful = false
                    })
                    .navigationBarBackButtonHidden(true)
                }
            }
            // APLICA EL CONTENEDOR AQUÍ
            .modelContainer(for: LeaveRequest.self)
        }
    }
}
