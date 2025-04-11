import SwiftUI

struct LoginView: View {
    
    @State private var usuario: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var showingUsuarioError = false
    @State private var isLoading = false
    @State private var errorMessage: String?
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
                    usuario: $usuario,
                    password: $password,
                    isPasswordVisible: $isPasswordVisible,
                    showingUsuarioError: $showingUsuarioError,
                    isLoginSuccessful: $isLoginSuccessful
                )
                .frame(width: 402, height: 429)
                .offset(y: 72)
                .padding(.bottom, 50)
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding(.top, 20)
                }
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }
            }
        }
    }
    
    private func handleLogin() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await AuthService.shared.login(usuario: usuario, password: password)
            print("✅ Login exitoso. Token recibido:", response.token.prefix(10), "...")
            isLoginSuccessful = true
        } catch {
            errorMessage = getErrorMessage(for: error)
            print("❌ Error en login:", error.localizedDescription)
        }
        
        isLoading = false
    }
    
    private func getErrorMessage(for error: Error) -> String {
        if let authError = error as? LocalizedError {
            return authError.errorDescription ?? "Error desconocido"
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .userAuthenticationRequired:
                return "Usuario o contraseña incorrectos"
            case .notConnectedToInternet:
                return "No hay conexión a internet"
            default:
                return "Error en la conexión"
            }
        }
        return error.localizedDescription
    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoginSuccessful: .constant(false))
    }
}
