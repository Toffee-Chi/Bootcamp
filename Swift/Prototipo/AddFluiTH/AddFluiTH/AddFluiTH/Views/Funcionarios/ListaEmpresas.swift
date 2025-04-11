import SwiftUI

struct ListaEmpresasView: View {
    let empresas: [Empresa]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(empresas) { empresa in
                        EmpresaCardView(empresa: empresa)
                    }
                }
                .padding(.vertical, 60)
            }


            Button(action: {
                print("Agregar nuevo funcionario")
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color("CustomBlue"))
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Funcionarios")
    }
}
