import SwiftUI

struct HomeContentView: View {
    //permite el acceso en previews
    @State var eventosHoy: [Evento] = []
    @State private var isLoading = false
    
    //constructor para mock data
    init(eventosHoy: [Evento] = []) {
        self._eventosHoy = State(initialValue: eventosHoy)
    }
    
    private var fechaActual: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d 'de' MMMM 'de' yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(spacing: 40) {
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
            
            // Fecha actual
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
            
            // Lista de eventos
            if isLoading {
                ProgressView()
                    .offset(y: -125)
            } else if !eventosHoy.isEmpty {
                EventosListView(eventos: eventosHoy)
                    .offset(y: -125)
            } else {
                Text("No hay eventos hoy")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .offset(y: -125)
            }
        }
        .task {
            await cargarEventos()
        }
    }
    
    //carga con manejo de errores
    private func cargarEventos() async {
        isLoading = true
        defer { isLoading = false }
        
        let token = UserDefaults.standard.string(forKey: "authToken")
        eventosHoy = await EventoManager.shared.obtenerEventosDeHoy(token: token)
        
#if DEBUG
        print("=== Eventos cargados ===")
        eventosHoy.forEach { evento in
            print("• \(evento.titulo) (\(evento.tipo))")
        }
#endif
    }
}
struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Vista normal (sin datos)
            HomeContentView()
                .previewDisplayName("Vista Vacía")
            
            // Vista con mock data usando el nuevo init
            HomeContentView(eventosHoy: [
                Evento(
                    titulo: "Feriado Nacional",
                    icono: "🎉",
                    color: .blue,
                    tipo: "feriado",
                    fecha: Date().formatted()
                ),
                Evento(
                    titulo: "Cumpleaños de Ana",
                    icono: "🎂",
                    color: .pink,
                    tipo: "cumpleaños",
                    fecha: Date().formatted()
                )
            ])
            .previewDisplayName("Con Eventos")
        }
    }
}
