//EJERCICIOS 2

//1)
/*
. Cargar un array de manera aleatoria con 10 números enteros del -5 al 5. Imprimirlo en
pantalla y computar cuál es el mayor elemento del vector
*/

var numeros = [0]  // Array vacío que almacenará enteros
var reemplazo = 0 // para comparar numeros de menor a mayor y reemplazarlos
     for i in 1...10{ //carga de datos al azar en el array
        numeros.append(Int.random(in: -5...5))
                     }
    print(numeros)
    //ciclo for para guardar el numero mayor entre ellos
    for i in 0...9{
        
          if reemplazo < numeros[i] {
              reemplazo = numeros[i]
          }else{
              print("...")
          }
    }
    print("emm: \(reemplazo)")

//2)
/*
Cargar un array de manera aleatoria con 100 números enteros del -30 al 30. Imprimirlo en
pantalla y computar cuál es el elemento que más veces se repite, y cuáles son los números
que no están presentes (si es que hay alguno).
*/
var numeros1:[Int] = []  // Array vacío que almacenará enteros

var numeroMayor = 0 // se inicializa con el menor para intercambiar en el for
var conteo: [Int: Int] = [:] // Diccionario para contar repeticiones
var Numero = 0


//print(conteo) Imprime el conteo de cada número

     for e in 1...100{ //carga de datos al azar en el array
        numeros1.append(Int.random(in: -30...30))
                     }
     //   print(numeros)
//primero vemos quienes tienen mas cantidad de veces el numero
        for i in numeros1 {
            conteo[i, default: 0] += 1 // Suma 1 al contador de cada número
                         }
           print(conteo)
  // vemos cual es el mayor
           for (numero, veces) in conteo {
                 if veces > numeroMayor {  // Si encontramos una cantidad de veces mayor
                     numeroMayor = veces
                     Numero = numero
                                    }
                                    }
print("numero \(Numero), se repitio con gran diferencia un total de  \(numeroMayor) veces")
           
let setOriginal = Set(-30...30)  // Convertimos a set
let setRandom = Set(numeros1)  // Convertimos a set

// Encontramos los elementos del setOriginal que no están en setRandom
let diferencia = setOriginal.subtracting(setRandom)

for i in diferencia {
    print("\n\(i) no está en el array de números aleatorios.\n")
}
    
//3)
/*
Hacer una función que, dada una palabra (String) o frase, diga si la misma es palíndrome o
no. Una palabra/frase palíndrome es aquella que se lee igual tanto de atrás para adelante,
como de adelante para atrás. Ejemplos de palíndromes: "MADAM", "RACECAR", "AMORE,
ROMA", "BORROW OR ROB", "WAS IT A CAR OR A CAT I SAW?"
*/

var FraseOPalabra:String = "" // se usara para la entrada de teclado
var PalabraOFrase:String = "" // sera el que detectara si es palindrome o no

print("Papu, Ingrese su epica frase o palabra Palindrome: \n")
FraseOPalabra = readLine()!

PalabraOFrase = String(FraseOPalabra.reversed())
//print(PalabraOFrase)

    if  PalabraOFrase == FraseOPalabra{
      print("Son iguales uwu: \(PalabraOFrase) y \(FraseOPalabra) ")
    }else{
        print("No son iguales papu")
        }

//4)
/*Dada una cadena de caracteres (String) de longitud desconocida que tiene solamente dígitos,
crear un array de N elementos (donde N es el tamaño de la cadena) que tenga cada uno de los
valores numéricos de los dígitos.
*/
var Cadenaint = "" // Cadena de dígitos
var arraycadena: [Int] = [] // Array de Ints
let numerorandom = Int.random(in: 1...1000) // Número aleatorio

// Convertir el número aleatorio en una cadena de texto

// Agregar cada dígito como entero al array
for caracter in 1...numerorandom {
    if let numero = Int(String(caracter)) {
        arraycadena.append(numero) // Convertir cada caracter a Int y agregar al array
    }
}

print(arraycadena) // Imprimir el array con los dígitos como Ints




