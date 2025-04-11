import SwiftUI

struct CardRowAprobado: View {
    var persona: ApprovedVacation

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(persona.nombre) \(persona.apellido)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)

                Spacer()

                Text("\(persona.fechaInicio) - \(persona.fechaFin)")
                    .font(.system(size: 14))
                    .foregroundColor(.green)

                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.green)
                                .frame(height: 10)
                                .clipShape(
                                    RoundedCornerShape(corners: [.bottomLeft, .bottomRight], radius: 12)
                                )
                        }
                    )
                    .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
            )
        }
        .padding(.horizontal)
    }
}
