import SwiftUI

struct FloatingLoginContainer: View {
    // Bindings
    @Binding var usuario: String
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    @Binding var showingUsuarioError: Bool
    @Binding var isLoginSuccessful: Bool
    
    // Estado para controlar la carga
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 40) {
            titleView
            formFields
            loginButton
            Spacer()
        }
        .containerStyle()
    }
    
    //Subviews
    private var titleView: some View {
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
        .padding(.top, 30)
    }
    
    private var formFields: some View {
        VStack(spacing: 25) {
            usuarioField
            passwordField
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
    
    private var usuarioField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Usuario")
                .font(.caption)
                .foregroundColor(.gray)
            
            ZStack(alignment: .leading) {
                if usuario.isEmpty {
                    Text("Ingrese su usuario")
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.leading, 16)
                }
                
                TextField("", text: $usuario)
                    .textFieldStyle(.plain)
                    .keyboardType(.numberPad)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .padding(.horizontal, 16)
                    .onChange(of: usuario) { _, newValue in
                        // Solo filtra números sin límite de longitud
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        usuario = filtered
                        showingUsuarioError = false
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(showingUsuarioError ? .red : .gray.opacity(0.3), lineWidth: 1)
                    )
            )
            
            validationMessage
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Contraseña")
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                if isPasswordVisible {
                    TextField("", text: $password)
                } else {
                    SecureField("", text: $password)
                }
                
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    private var loginButton: some View {
        Button {
            Task {
                await performLogin()
            }
        } label: {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text("Ingresar")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 200, height: 50)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(isButtonDisabled ? .gray : .yellow)
        )
        .disabled(isButtonDisabled || isLoading)
        .animation(.easeInOut(duration: 0.3), value: isButtonDisabled)
    }
    
    private var validationMessage: some View {
        Group {
            if showingUsuarioError {
                Text("Usuario inválido")
                    .font(.caption)
                    .foregroundColor(.red)
            } else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else if !isButtonDisabled {
                Text("Perfecto Todo! :)")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
    }
    // Lógica
    private var isButtonDisabled: Bool {
        password.isEmpty || usuario.isEmpty
    }
    
    private func performLogin() async {
        isLoading = true
        errorMessage = ""
        
        do {
            guard !usuario.isEmpty, !password.isEmpty else {
                throw ValidationError.emptyFields
            }
            
            //recibe un LoginResponse
            let response = try await AuthService.shared.login(
                usuario: usuario,
                password: password
            )
            
            print("Token recibido:", response.token)
            
            //Guarda el token
            guard KeychainHelper.saveString(key: "authToken", value: response.token) else {
                throw NSError(domain: "KeychainError", code: -1,
                              userInfo: [NSLocalizedDescriptionKey: "Error al guardar el token"])
            }
            
            //Guarda el ID de usuario
            UserDefaults.standard.set(usuario, forKey: "userId")
            
            DispatchQueue.main.async {
                isLoginSuccessful = true
            }
            
        } catch let error as URLError where error.code == .userAuthenticationRequired {
            errorMessage = "Usuario o contraseña incorrectos"
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
    private func handleURLError(_ error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet:
            return "Sin conexión a internet"
        case .timedOut:
            return "Tiempo de espera agotado"
        case .cannotFindHost, .cannotConnectToHost:
            return "No se puede conectar al servidor"
        case .badServerResponse:
            return "Respuesta inválida del servidor"
        case .userAuthenticationRequired:
            return "Usuario o contraseña incorrectos"
        default:
            return "Error de conexión: \(error.localizedDescription)"
        }
    }

//Helper
private enum ValidationError: Error, LocalizedError {
    case emptyFields
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            return "Por favor complete todos los campos"
        case .invalidCredentials:
            return "Usuario o contraseña incorrectos"
        }
    }
}

//Extensión para el estilo
private extension View {
    func containerStyle() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
}

// Preview
struct FloatingLoginContainer_Previews: PreviewProvider {
    static var previews: some View {
        FloatingLoginContainer(
            usuario: .constant(""),
            password: .constant(""),
            isPasswordVisible: .constant(false),
            showingUsuarioError: .constant(false),
            isLoginSuccessful: .constant(false)
        )
    }
}
