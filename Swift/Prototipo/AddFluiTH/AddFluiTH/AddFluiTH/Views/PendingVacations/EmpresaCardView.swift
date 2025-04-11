import SwiftUI

struct EmpresaCardView: View {
    let empresa: Empresa
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(empresa.nombre)
                    .font(.headline)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(empresa.funcionarios.filter { $0.estado == .verde }.count) 🟢")
                    Text("\(empresa.funcionarios.filter { $0.estado == .amarillo }.count) 🟠")
                    Text("\(empresa.funcionarios.filter { $0.estado == .rojo }.count) 🔴")
                }
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)

            if isExpanded {
                ForEach(empresa.funcionarios) { funcionario in
                    HStack {
                        Circle()
                            .fill(color(for: funcionario.estado))
                            .frame(width: 10, height: 10)
                        Text(funcionario.nombre)
                            .font(.subheadline)
                    }
                    .padding(.leading)
                }
            }
        }
        .padding(.horizontal)
    }

    func color(for estado: Estado) -> Color {
        switch estado {
        case .verde: return .green
        case .amarillo: return .yellow
        case .rojo: return .red
        }
    }
}
