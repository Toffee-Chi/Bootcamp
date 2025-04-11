import SwiftUI

// Modelo de datos
struct Evento: Identifiable {
    let id = UUID()
    let titulo: String
    let icono: String
    let color: Color
    let tipo: String // "feriado" o "cumpleaños"
    let fecha: String // Formato YYYY-MM-DD
}

//Vista que contiene la lógica de la lista horizontal
struct EventosListView: View {
    // Datos dinámicos
    let eventos: [Evento]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Eventos Hoy")
                .font(.headline)
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(eventos) { evento in
                        EventoCard(evento: evento)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// Tarjeta individual
struct EventoCard: View {
    let evento: Evento
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(evento.icono)
                    .font(.title)
                Text(evento.titulo)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            Text(evento.tipo.uppercased())
                .font(.caption2)
                .foregroundColor(evento.color)
        }
        .padding(10)
        .background(evento.color.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(evento.color, lineWidth: 1)
        )
    }
}
