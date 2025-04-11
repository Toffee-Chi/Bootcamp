import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    var onFinish: () -> Void //Callback para cambiar de pantalla
    
    var body: some View {
        ZStack {
            // Fondo aesthetic
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Contenido central (logo + texto)
            VStack {
                Image("ic_roshka_normal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150 * scale, height: 150 * scale)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0)) {
                scale = 2.4
                opacity = 1.0
            }
            //Espera 2.5 segundos y cambia de vista
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinish()
            }
        }
    }
}
