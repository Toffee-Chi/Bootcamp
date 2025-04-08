import SwiftUI

struct Login: View {
    @State private var isSplashActive = false
    @Binding var isLoginSuccessful: Bool
    
    var body: some View {
        ZStack {
            if isSplashActive {
                LoginView(isLoginSuccessful: $isLoginSuccessful)
            } else {
                SplashView {
                    withAnimation {
                        isSplashActive = true
                    }
                }
            }
        }
    }
}

struct LoginView: View {
    @State private var usuario: String = "" // Cambiado de email a usuario
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var showingUsuarioError = false // Cambiado de emailError
    @Binding var isLoginSuccessful: Bool

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Image("ic_roshka_white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 100)
                    .padding(.top, 99)
                    .offset(y: 52)
                
                Spacer()
                
                FloatingLoginContainer(
                    usuario: $usuario, // Cambiado a usuario
                    password: $password,
                    isPasswordVisible: $isPasswordVisible,
                    showingUsuarioError: $showingUsuarioError, // Cambiado
                    isLoginSuccessful: $isLoginSuccessful
                )
                .frame(width: 402, height: 429)
                .offset(y: 72)
                .padding(.bottom, 50)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(isLoginSuccessful: .constant(false))
    }
}
