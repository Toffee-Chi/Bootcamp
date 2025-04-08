import SwiftUI
import Foundation
struct FloatingResumeList: View {
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .firstTextBaseline, spacing: 108) {
                    Text("Resumen")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .offset(y: -20)
                    Image("weatherMoon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                }
                .padding(.bottom, 10)
                rowItem(icon: "ic_circle_green", title: "Vacaciones", count: "1")
                rowItem(icon: "ic_circle_orange", title: "Reposo", count: "3")
                rowItem(icon: "ic_circle_red", title: "Vacaciones", count: "2")
                rowItem(icon: "ic_circle_blue", title: "Trabajando", count: "232")
            }
            .padding(20)
            .frame(width: 350)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
        )
        .offset(y: -130)
        .offset(x:-100)
    }
    // Componente reutilizable para cada fila
    func rowItem(icon: String, title: String, count: String) -> some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFill()
                .frame(width: 15, height: 15)
            
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading) // ocupa espacio y empuje los números
            
            Text(count)
                .font(.system(size: 20))
                .foregroundColor(.black)
        }
        .padding(.vertical, 5) //Espacio entre filas
    }
}

