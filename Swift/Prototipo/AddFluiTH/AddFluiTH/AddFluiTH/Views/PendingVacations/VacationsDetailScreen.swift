import SwiftUI

struct VacationDetailScreen: View {
    var persona: PendingVacation

    var body: some View {
        VStack(spacing: 20) {
            Text("\(persona.nombre) \(persona.apellido)")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text("Inicio de vacaciones: \(persona.fechaInicio)")
                .font(.title3)

            Text("Fin de vacaciones: \(persona.fechaFin)")
                .font(.title3)

            Spacer()
        }
        .padding()
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    VacationDetailScreen(persona: PendingVacation.mockup())
}
