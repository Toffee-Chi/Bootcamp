// JUEGO NIM

import Foundation

// Generamos las variables randoms y otra con el total de los mismos para generar un bucle
var Pila1 = Int.random(in: 1...9)
var Pila2 = Int.random(in: 1...9)
var Pila3 = Int.random(in: 1...9)
var totalPila: Int = Pila1 + Pila2 + Pila3

// Presentamos la intro, y le pedimos el nickname a los jugadores
print("Bienvenido a Nim:")
print("Por si no sabías papu, estas son las reglas del juego:")
print("Mentí, no voy a decir nada más, jajaja.\n")

print("Jugador 1 ingrese su NickName: ")
let jugador1 = readLine()!
print("Jugador 2 ingrese su NickName: ")
let jugador2 = readLine()!

// Empieza el ciclo
while totalPila > 0 {
//Empezamos primero con el jugador 1, le pedimos que eliga la pila y el monto
    print("Elige una pila, \(jugador1):  \n1.Pila 1; \(Pila1) \n2.Pila 2; \(Pila2)  \n3.Pila 3; \(Pila3)")
    //validamos primero si se pudo convertir el texto a numero
    let stringChoice = readLine()!
    if let choice1 = Int(stringChoice) {
    //empezamos el ciclo para reducir la pila seleccionada
        switch choice1 {
        case 1:
            print("\nIngrese la cantidad que desee quitar de la pila: ")
            let stringChoice2 = readLine()!
            if let choice2 = Int(stringChoice2), choice2 <= Pila1 {
                Pila1 -= choice2
                totalPila -= choice2
            } else {
                print("Pinchaste o el valor no es válido.")
                exit(0)
            }
        case 2:
            print("\nIngrese la cantidad que desee quitar de la pila: ")
            let stringChoice3 = readLine()!
            if let choice3 = Int(stringChoice3), choice3 <= Pila2 {
                Pila2 -= choice3
                totalPila -= choice3
            } else {
                print("Pinchaste o el valor no es válido.")
                exit(0)
            }
        case 3:
            print("\nIngrese la cantidad que desee quitar de la pila: ")
            let stringChoice4 = readLine()!
            if let choice4 = Int(stringChoice4), choice4 <= Pila3 {
                Pila3 -= choice4
                totalPila -= choice4
            } else {
                print("Pinchaste o el valor no es válido.")
                exit(0)
            }
            //en caso de que no funcione la conversion
        default:
            print("Opción inválida.")
        }
    } else {
        print("Entrada no válida.")
    }
    
    if totalPila == 0{
        print("OAAAAAA GANO EL SKIBIDI \(jugador1)")
    }else{}
    
        print("Elige una pila, \(jugador2):  \n1.Pila 1; \(Pila1) \n2.Pila 2; \(Pila2)  \n3.Pila 3; \(Pila3)")
    //validamos primero si se pudo convertir el texto a numero
    let stringchoice = readLine()!
    if let Choice1 = Int(stringchoice) {
    //empezamos el ciclo para reducir la pila seleccionada
        switch Choice1 {
        case 1:
            print("\nIngrese la cantidad que desee quitar de la pila: ")
            let stringchoice2 = readLine()!
            if let Choice2 = Int(stringchoice2), Choice2 <= Pila1 {
                Pila1 -= Choice2
                totalPila -= Choice2
            } else {
                print("Pinchaste o el valor no es válido.")
                exit(0)
            }
        case 2:
            print("\nIngrese la cantidad que desee quitar de la pila: ")
            let stringchoice3 = readLine()!
            if let Choice3 = Int(stringchoice3), Choice3 <= Pila2 {
                Pila2 -= Choice3
                totalPila -= Choice3
            } else {
                print("Pinchaste o el valor no es válido.")
                exit(0)
            }
        case 3:
            print("\nIngrese la cantidad que desee quitar de la pila: ")
            let stringchoice4 = readLine()!
            if let Choice4 = Int(stringchoice4), Choice4 <= Pila3 {
                Pila3 -= Choice4
                totalPila -= Choice4
            } else {
                print("Pinchaste o el valor no es válido.")
                exit(0)
            }
            //en caso de que no funcione la conversion
        default:
            print("Opción inválida.")
        }
    } else {
        print("Entrada no válida.")
    }
       if totalPila == 0{
        print("OAAAAAA GANO EL SKIBIDI \(jugador2)")
    }else{}
}
