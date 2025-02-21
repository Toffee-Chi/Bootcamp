import Foundation

func generarNumeroSecreto() -> [Int] {
    var numeros: [Int] = []
    while numeros.count < 4 {
        let nuevoNumero = Int.random(in: 1...9)
        if !numeros.contains(nuevoNumero) {
            numeros.append(nuevoNumero)
        }
    }
    return numeros
}

func obtenerEntradaValida() -> [Int]? {
    print("Ingrese su jugada de 4 dígitos: ", terminator: "")
    guard let input = readLine(), input.count == 4, let _ = Int(input) else {
        print("Entrada no válida. Debe ser un número de 4 dígitos únicos.")
        return nil
    }
    let digitos = input.compactMap { $0.wholeNumberValue }
    return Set(digitos).count == 4 ? digitos : nil
}

func contarTorosYVacas(numeroSecreto: [Int], intento: [Int]) -> (toros: Int, vacas: Int) {
    var toros = 0
    var vacas = 0
    for i in 0..<4 {
        if intento[i] == numeroSecreto[i] {
            toros += 1
        } else if numeroSecreto.contains(intento[i]) {
            vacas += 1
        }
    }
    return (toros, vacas)
}

let numeroSecreto = generarNumeroSecreto()
print("\n¡Bienvenido a Vacas y Toros!")
print("Adivina el número de 4 dígitos sin repetir. ¡Buena suerte!\n")

while true {
    guard let intento = obtenerEntradaValida() else { continue }
    let resultado = contarTorosYVacas(numeroSecreto: numeroSecreto, intento: intento)
    
    if resultado.toros == 4 {
        print("\n¡Felicidades! Adivinaste el número: \(numeroSecreto.map { String($0) }.joined())")
        break
    } else {
        print("\n\(resultado.toros) Toros, \(resultado.vacas) Vacas. Inténtalo de nuevo.\n")
    }
}
