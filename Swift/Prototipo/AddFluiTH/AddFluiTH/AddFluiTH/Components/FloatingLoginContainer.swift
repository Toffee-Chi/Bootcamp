import SwiftUI

struct FloatingLoginContainer: View {
    //Bindings
    @Binding var usuario: String
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    @Binding var showingUsuarioError: Bool
    @Binding var isLoginSuccessful: Bool
    
    //Estados
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showPasswordRules = false
    
    //Body
    var body: some View {
        VStack(spacing: 40) {
            titleView
            formFields
            loginButton
            Spacer()
        }
        .containerStyle()
        .alert("Error de autenticación", isPresented: .constant(!errorMessage.isEmpty)) {
            Button("OK") { errorMessage = "" }
        } message: {
            Text(errorMessage)
        }
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
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            usuario = filtered
                            showingUsuarioError = true
                        } else {
                            showingUsuarioError = false
                        }
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
            HStack {
                Text("Contraseña")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button {
                    showPasswordRules.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                }
                .popover(isPresented: $showPasswordRules) {
                    Text("La contraseña debe contener:\n• 8 caracteres mínimo\n• 1 mayúscula\n• 1 número")
                        .padding()
                        .frame(width: 250)
                }
            }
            
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
                Text("Solo se permiten números")
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
    
    //Lógica
    private var isButtonDisabled: Bool {
        password.isEmpty || usuario.isEmpty
    }
    
    private func performLogin() async {
        isLoading = true
        errorMessage = ""
        
        // Debug: Limpiar posibles tokens previos
        KeychainHelper.delete(key: "authToken")
        print("🧹 Keychain limpiado antes del login")
        
        do {
            // 1. Validación básica de campos
            guard !usuario.isEmpty, !password.isEmpty else {
                throw ValidationError.emptyFields
            }
            
            // 2. Llamada al servicio de autenticación
            print("🔵 Iniciando proceso de login...")
            let response = try await AuthService.shared.login(
                usuario: usuario,
                password: password
            )
            
            print("✅ Token recibido (primeros 10 chars):", response.token.prefix(10), "...")
            
            // 3. Verificación EXTENDIDA del token guardado
            let verificationRetries = 3
            var isTokenVerified = false
            
            for attempt in 1...verificationRetries {
                print("🔍 Intento de verificación \(attempt)/\(verificationRetries)")
                
                if let savedToken = KeychainHelper.loadString(key: "authToken") {
                    if savedToken == response.token {
                        print("🔑 Token verificado correctamente en Keychain")
                        isTokenVerified = true
                        break
                    } else {
                        print("❌ Token no coincide en el intento \(attempt)")
                    }
                } else {
                    print("❌ No se encontró token en Keychain (intento \(attempt))")
                }
                
                if attempt < verificationRetries {
                    await Task.sleep(500_000_000) // Espera 0.5 segundos
                }
            }
            
            // 4. Manejo del resultado
            if isTokenVerified {
                DispatchQueue.main.async {
                    isLoginSuccessful = true
                }
            } else {
                print("🔴 Falla crítica: Token no persistido correctamente")
                throw AuthError.keychainError
            }
            
        } catch let error as AuthError {
            // Manejo específico de errores de autenticación
            switch error {
            case .apiError(let message):
                errorMessage = message
                print("❌ Error de API:", message)
            case .keychainError:
                errorMessage = "Error al guardar credenciales. Intente nuevamente."
                print("🔴 Fallo crítico en Keychain")
            case .invalidResponse:
                errorMessage = "Respuesta inválida del servidor"
            }
            
        } catch let urlError as URLError {
            // Manejo de errores de red
            errorMessage = handleURLError(urlError)
            print("🌐 Error de red:", urlError.localizedDescription)
            
        } catch {
            // Error genérico
            errorMessage = "Error inesperado. Por favor contacte al soporte."
            print("⚠️ Error desconocido:", error.localizedDescription)
        }
        
        // 5. Limpieza final
        isLoading = false
        
        // Debug adicional si persiste el error
        #if DEBUG
        if !errorMessage.isEmpty {
            print("🔍 Estado actual de Keychain:")
            let tokenExists = KeychainHelper.loadString(key: "authToken") != nil
            print(" - Token en Keychain:", tokenExists ? "✅" : "❌")
            
            // Verificar UserDefaults como respaldo (solo para debug)
            if let debugToken = UserDefaults.standard.string(forKey: "debugAuthToken") {
                print(" - Token en UserDefaults:", debugToken.prefix(10), "...")
            }
        }
        #endif
    }
    
    private func handleURLError(_ error: URLError) -> String {
        switch error.code {
        case .notConnectedToInternet:
            return "Sin conexión a internet"
        case .timedOut:
            return "Tiempo de espera agotado"
        case .userAuthenticationRequired:
            return "Usuario o contraseña incorrectos"
        default:
            return "Error de conexión (\(error.code.rawValue))"
        }
    }
}

//Helpers
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

private enum KeychainError: Error, LocalizedError {
    case saveFailed
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Error al guardar credenciales"
        }
    }
}

//Estilos de los containers
private extension View {
    func containerStyle() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
}

//Preview
struct FloatingLoginContainer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Vista normal
            FloatingLoginContainer(
                usuario: .constant(""),
                password: .constant(""),
                isPasswordVisible: .constant(false),
                showingUsuarioError: .constant(false),
                isLoginSuccessful: .constant(false)
            )
            
            // Vista con error
            FloatingLoginContainer(
                usuario: .constant("123"),
                password: .constant(""),
                isPasswordVisible: .constant(false),
                showingUsuarioError: .constant(true),
                isLoginSuccessful: .constant(false)
            )
            .previewDisplayName("Con Error")
        }
    }
}
