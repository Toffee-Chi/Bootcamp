import SwiftUI

struct Funcionarios: View {
    var body: some View {
        NavigationView {
            ListaEmpresasView(empresas: [
                Empresa(nombre: "Itaú", funcionarios: [
                    Funcionario(nombre: "Isabella Torres", estado: .verde),
                    Funcionario(nombre: "Martín López", estado: .rojo)
                ]),
                Empresa(nombre: "Bancop", funcionarios: [
                    Funcionario(nombre: "Sebastián Torres", estado: .amarillo),
                    Funcionario(nombre: "Mariana Gómez", estado: .amarillo),
                    Funcionario(nombre: "Isabella Torres", estado: .verde)
                ]),
                Empresa(nombre: "GNB", funcionarios: []),
                Empresa(nombre: "Roshka Studios", funcionarios: [
                    Funcionario(nombre: "Isabella Torres", estado: .verde),
                    Funcionario(nombre: "Mariana Gómez", estado: .amarillo),
                    Funcionario(nombre: "Sebastián Torres", estado: .amarillo),
                    Funcionario(nombre: "Martín López", estado: .rojo)
                ])
            ])
        }
    }
}
