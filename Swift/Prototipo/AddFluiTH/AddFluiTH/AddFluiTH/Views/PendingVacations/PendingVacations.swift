import SwiftUI
struct CardRow: View {
    var persona: PendingVacation  // Estructura con los datos de la persona
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack() {
                    Text("\(persona.nombre) \(persona.apellido)")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    Text("\(persona.fechaInicio) - \(persona.fechaFin)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()

                Image(systemName: "arrow.up.right.square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.blue)
            }
            .padding(.vertical)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay(           // Rectangulo verde
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.gray,
                                            Color.white,
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 10)
                            
                                .clipShape(
                                    RoundedCornerShape(
                                        corners: [.bottomLeft, .bottomRight],
                                        radius: 12)
                                )
                             
                        }
                    )
                    .shadow(
                        color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
            )

        }
        .padding(.horizontal)
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    CardRow(
        persona: PendingVacation.mockup())
}
