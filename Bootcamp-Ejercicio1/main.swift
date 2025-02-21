//EJERCICIO 1


/*Declara dos variables numéricas (con el valor que desees), muestra por consola la
suma, resta, multiplicación, división y módulo (resto de la división).
*/

var primeravariable:Int = 23 //primera variable para los operadores
var segundavariable:Int=21 //segunda variable para los operadores
var operaaciones:Int=0  //realizamos las operaciones basicas y las cargamos


operaaciones = primeravariable + segundavariable
    print(operaaciones)
    operaaciones = 0
operaaciones = primeravariable - segundavariable
    print(operaaciones)
    operaaciones = 0
operaaciones = primeravariable / segundavariable
    print(operaaciones)
    operaaciones = 0
operaaciones = primeravariable * segundavariable
    print(operaaciones)


/*
 Declara 2 variables numéricas (con el valor que desees), he indica cual es mayor de los dos.
Si son iguales indicarlo también. Ves cambiando los valores para comprobar que funciona.
 */
var primeraVariable:Int = 10  //primera variable numerica
var segundaVariable:Int = 10  // segunda variable numerica
//switch para validar si son iguales, mayor o menor.
    switch true{
        case primeraVariable > segundaVariable: print("El mayor es \(primeraVariable)")
        case primeraVariable < segundaVariable: print("El mayor es \(segundaVariable)")
        case primeraVariable == segundaVariable: print("Ambos numeros son iguales papu, \(primeraVariable), \(segundaVariable)")
//si se ingresa algo inesperado
        default: print("Que paso aca?")
}


/*
 Declara un String que contenga tu nombre, después muestra un mensaje de bienvenida
 por consola. Por ejemplo: si introduzco “Fernando”, me aparezca “Bienvenido Fernando
 */
var name = "Kevin"
    print("Bienvenido \(name)")


/*
 Modifica la aplicación anterior, para que nos pida el nombre que queremos introducir.
 */
        print("Ingresa tu nombre: ")
    if let names = readLine(){
        print("Bienvenido \(names)")
}

/*
 Lee un número por teclado e indica si es divisible entre 2 (resto = 0). Si no lo es,
también debemos indicarlo
 */

        print("Ingresa un número entero:")
//condicion para verificar que se pueda convertir lo que se ingreso por teclado
    if let input = readLine(), let number = Int(input) {
    if number % 2 == 0 { //operador para verificar si es divisible por 2 o por 3 con la operacion
        print("\(number) es divisible entre 2.")
            } else {
        print("\(number) no es divisible entre 2.")
            }
                    } else {
        print("Entrada inválida. Por favor, ingresa un número entero válido.")
}

/*
 Lee un número por teclado que pida el precio de un producto (puede tener
 decimales) y calcule el precio final con IVA. El IVA sera una constante que sera del
 10%
 */

let IVA: Float = 0.10 //inicializamos el iva para la operacion
      print("Ingresa el precio del producto:")
// condicional para saber si se convirtio bien la variable y comenzar con las operaciones si es asi
    if let input = readLine(), let precio = Float(input) {
        let montoIVA = precio * IVA
        let precioFinal = precio + montoIVA

            print("Precio final con IVA: \(precioFinal)")
        } else { // sino, volver a intentar
            print("Entrada inválida. Por favor, ingresa un número válido.")
                }

/*
 Muestra los numeros del 1 al 100(ambo incluidos) divisibles entre 2 y 3
 */
for i in 0...100{ //ciclo for para verificar de uno en uno los divisibles
    
    if i % 2 == 0{
        print ("del 2: \(i)")
    }else if i % 3 == 0{
        print("del 3: \(i)")
    }
    
    
}

/*
 Lee un número por teclado y comprueba que este numero es mayor o igual que cero, si
 no lo es lo volverá a pedir (do while), después muestra ese número por consola.
 */
//variable para utilizar en el ciclo
var number:Int
    repeat {
        print("Ingresa un número:")
    //ciclo para verificar si se convirtio bien la variable
        if let input = readLine(), let value = Int(input) {
            number = value
         } else {
             number = 0
            }
        if number >= 0{
                print("es mayor o igual que cero")
            }else{
                    print("no es mayor o igual que cero")
                }
    
    } while number <= 0

/*
e escribe una aplicación con un String que contenga una contraseña cualquiera. Después
 se te pedirá que introduzcas la contraseña, con 3 intentos. Cuando aciertes ya no pedirá
 mas la contraseña y mostrara un mensaje diciendo “Correcto!”. Piensa bien en la
 condición de salida (3 intentos y si acierta sale, aunque le queden intentos, si no acierta
 en los 3 intentos mostrar el mensaje “Fallaste jaja!!”)
 */
//contraseña de inicio para probar la seguridad
let pass:String = "Pepere3"
    //ciclo de 3 intentos, si acierta cierra el ciclo for
    for i in 1...3{
        print("Ingresa tu pass: ")
            if    let npass = readLine(){
                print("Procesando...")
            if npass == pass {
                    print("Correcto!")
                break
            }else{
                print("Fallaste, jaja! STRIKE \(i) DE 3!")
               }
    }else{
    print("fallo tecnico")
}
    
}
/*
 Crea una aplicación que nos pida un día de la semana y que nos diga si es un dia
 laboral o no (“De lunes a viernes consideramos dias laborales”)
 */
//se inicia la presentacion para elegir mediante los digitos el dia de la semana
print("ingresa segun la opcion, un dia de la semana: ")
print("1.Lunes, 2.Martes, 3.Miercoles ")
print("4.Jueves, 5.Viernes, 6.Sabado ")
print("7.Domingo")
// condicional en donde se valida la conversion y luego el switch para reducir el codigo.
if let day = readLine(), let dayp = Int(day){
    switch dayp{
        case 1,2,3,4,5: print("Dia de laburo")
        case 6,7: print("HOLIDAYYY")
        default: print("un numero te pedi no escribas pls")
        }
}else{
        print("error tecnico")
}
