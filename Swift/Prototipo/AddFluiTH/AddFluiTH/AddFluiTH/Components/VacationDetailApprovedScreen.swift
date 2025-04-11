import SwiftUI

struct VacationDetailApprovedScreen: View {
    var persona: ApprovedVacation

    var body: some View {
        VStack(spacing: 20) {
            Text("\(persona.nombre) \(persona.apellido)")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            Text("Inicio: \(persona.fechaInicio)")
                .font(.title3)

            Text("Fin: \(persona.fechaFin)")
                .font(.title3)

            Spacer()
        }
        .padding()
        .navigationTitle("Detalle Aprobado")
        .navigationBarTitleDisplayMode(.inline)
    }
}
