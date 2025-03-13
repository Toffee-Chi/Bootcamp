import UIKit

class PokerGame: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    //cartas del jugador del view
    @IBOutlet weak var card1Image: UIImageView!
    @IBOutlet weak var card2Image: UIImageView!
    @IBOutlet weak var card3Image: UIImageView!
    @IBOutlet weak var card4Image: UIImageView!
    @IBOutlet weak var card5Image: UIImageView!
    
    //cartas del bot del view
    @IBOutlet weak var cardBot1: UIImageView!
    @IBOutlet weak var cardBot2: UIImageView!
    @IBOutlet weak var cardBot3: UIImageView!
    @IBOutlet weak var cardBot4: UIImageView!
    @IBOutlet weak var cardBot5: UIImageView!
    
    //texto de la conciencia de ambos
    @IBOutlet weak var labelGanador: UILabel!
    @IBOutlet weak var labelScoreBot: UILabel!
    @IBOutlet weak var labelScoreJugador: UILabel!
    @IBOutlet weak var labelBotConcien: UILabel!
    @IBOutlet weak var labelConcien: UILabel!
    
    //para desempate
    // Definir variables para almacenar la carta más alta
    var hightCardJugador = 0
    var hightCardBot = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func randomCarts(_ sender: Any) {
        
        //jugador1:
        
        let spades: [String: Int] = ["AS": 1, "2S": 2, "3S": 3, "4S": 4, "5S": 5, "6S": 6, "7S": 7, "8S": 8, "9S": 9, "TS": 10, "JS": 11, "QS": 12, "KS": 13]
        let clubs: [String: Int] = ["AC": 1, "2C": 2, "3C": 3, "4C": 4, "5C": 5, "6C": 6, "7C": 7, "8C": 8, "9C": 9, "TC": 10, "JC": 11, "QC": 12, "KC": 13]
        let hearts: [String: Int] = ["AH": 1, "2H": 2, "3H": 3, "4H": 4, "5H": 5, "6H": 6, "7H": 7, "8H": 8, "9H": 9, "TH": 10, "JH": 11, "QH": 12, "KH": 13]
        let diamonds: [String: Int] = ["AD": 1, "2D": 2, "3D": 3, "4D": 4, "5D": 5, "6D": 6, "7D": 7, "8D": 8, "9D": 9, "TD": 10, "JD": 11, "QD": 12, "KD": 13]
        
        //puntaje del bot y del jugador dependiendo de lo que le toque
        var puntajeBot = 0
        var puntajeJugador = 0
        
        // Unir todos los diccionarios en un solo mazo
        var deck = spades.merging(clubs) { _, new in new }
                      .merging(hearts) { _, new in new }
                      .merging(diamonds) { _, new in new }

        // Mezclar las cartas y tomar 5 sin repetir
        let selectedCards = Array(deck.shuffled().prefix(5))

        // Imprimir las cartas seleccionadas en la consola (opcional, solo para verificar)
        for (nombre, valor) in selectedCards {
            print("La carta seleccionada es \(nombre) con un valor de \(valor).")
            
        }
        hightCardJugador = selectedCards.map { $0.value }.max() ?? 0
        print("oaaee ju : \(hightCardJugador)")
        // Asignar las imágenes a las cinco cartas en pantalla
        let imageViews = [card1Image, card2Image, card3Image, card4Image, card5Image]
         
         for (index, card) in selectedCards.enumerated() {
             if index < imageViews.count { // Asegurar que no exceda el número de `UIImageView`
                 let imageName = "\(card.key).png"
                 imageViews[index]?.image = UIImage(named: imageName)
             }
         }
        // Función para verificar Escalera Color
        func isEscaleraColor(cards: [(key: String, value: Int)]) -> Bool {
            let palo = cards.first!.key.suffix(1) // Último carácter de la clave, que es el palo
            
            if !cards.allSatisfy({ $0.key.hasSuffix(String(palo)) }) {
                return false
            }
            
            let sortedCards = cards.sorted { $0.value < $1.value }
            
            for i in 0..<sortedCards.count-1 {
                if sortedCards[i].value + 1 != sortedCards[i + 1].value {
                    return false
                }
            }
            
            let asLow = ["AS", "2S", "3S", "4S", "5S"]
            let asHigh = ["TS", "JS", "QS", "KS", "AS"]
            if (cards.map { $0.key }.sorted() == asLow || cards.map { $0.key }.sorted() == asHigh) {
                return true
            }
            
            return true
        }

        // Función para verificar Four of a Kind
        func cuatroIguales(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 4 }  // Si hay un número con frecuencia 4
        }
        //funcion que se une con tresIguales para hacer un Color y tambien para validar si tiene Dos Iguales.
        func dosIguales(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 2 }  // Si hay un número con frecuencia 4
        }
        //funcion que se une con dosIguales para hacer un Color

        func tresIguales(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 3 }  // Si hay un número con frecuencia 4
        }
        //funcion para validar si tiene Escalera
        func cincoIguales(cards: [(key: String, value: Int)]) -> Bool {
            let palo = cards.first!.key.suffix(1) // Último carácter de la clave, que es el palo
            if !cards.allSatisfy({ $0.key.hasSuffix(String(palo)) }) {
                return false
            }
            return true
        }
        // funcion para validar si tiene Doble Par
        func doblePar(cards: [(key: String, value: Int)]) -> Bool {
            // Contar la cantidad de veces que aparece cada valor
            var countValues: [Int: Int] = [:]

            for card in cards {
                countValues[card.value, default: 0] += 1
            }

            // Contar cuántos valores aparecen exactamente 2 veces
            let pairs = countValues.values.filter { $0 == 2 }.count

            // Debe haber exactamente dos pares
            return pairs == 2
        }
        //funcion para validar si tiene AS
        func tieneAs(cards: [(key: String, value: Int)]) -> Bool {
            return cards.contains { $0.key.hasPrefix("A") }
        }

        
       // Usar el switch para verificar la jugada y mostrar el resultado en pantalla
        switch true {
        case isEscaleraColor(cards: selectedCards):
            labelConcien.text = "¡Vamos! Tienes la mano. Solo un poco más, un paso más y puedes llegar. El camino es estrecho, pero ya estás en él. ¿Vas a rendirte ahora?"
            puntajeJugador = 30
        case cuatroIguales(cards: selectedCards):
            labelConcien.text = "¡Lo lograste, lo hiciste! Escalera Color, las cartas están alineadas como si el universo te estuviera dando una señal, ¡Este es tu momento! ¿Lo sientes? El destino susurra en tus oídos, ¿y tú vas a dejarlo pasar?"
            puntajeJugador = 25

        case dosIguales(cards: selectedCards) && tresIguales(cards: selectedCards):
            labelConcien.text = "¡Increíble! Poker, cuatro del mismo tipo... ¡Esto es grande! ¡Cuatro cartas! ¡Es demasiado! ¿El azar está de tu lado o es pura magia? El universo nunca fue tan claro. ¡Tienes que seguir, ahora sí!"
            puntajeJugador = 20

        case cincoIguales(cards: selectedCards):
            labelConcien.text = "Una secuencia... una Escalera. ¡Estás cerca!¡Vamos! Tienes la mano. Solo un poco más, un paso más y puedes llegar. El camino es estrecho, pero ya estás en él. ¿Vas a rendirte ahora? "
            puntajeJugador = 15

        case tresIguales(cards: selectedCards):
            labelConcien.text = "No es el combo que esperabas, pero Trío, ¿te suena familiar? Es... algo. ¿Es suficiente? ¿O esta solo es otra parte del viaje hacia lo grande? Tal vez no ahora, pero aún tienes tiempo. No dejes que el silencio te consuma, no aún."
            puntajeJugador = 10

        case doblePar(cards: selectedCards):
            labelConcien.text = "dos pares, pero... ¿es todo lo que tienes? ¿Te conformas con esto? O... tal vez esto es solo el principio. Dos veces. Solo dos, y la jugada puede cambiar. No mires atrás, no ahora."
            puntajeJugador = 5

        case dosIguales(cards: selectedCards):
            labelConcien.text = "Un par. Un suspiro ahogado en la nada. ¿Es esto lo que quieres? ¿Lo que soñaste? La desesperación retumba... un golpe. Un eco lejano. ¿Te quedas aquí? ¿O te levantas y sigues buscando?"
            puntajeJugador = 4

        case tieneAs(cards: selectedCards):
            labelConcien.text = "Solo un As. Un As. El rey de los momentos vacíos. Solo eso. Nada más. ¿Lo sientes? El vacío que se cierne sobre ti. Te preguntas si fue suficiente, si alguna vez será. Pero ahí está... Solo tú y el As. Una carta más. ¿Es esta la última oportunidad?"
            puntajeJugador = 3

        default:
            labelConcien.text = "Mierda.. Solo las sombras del fracaso, las cartas que no fueron. Te preguntas, ¿será esta la vez que todo se derrumba? Pero aún estás aquí. ¿Y qué es el fracaso, sino solo un susurro entre las oportunidades que vienen? ¿Sigues, o... te quedas atrapado en el eco?"
            puntajeJugador = 0

        }
        
        
        
        //bot:
        //evita que tenga los mismos elementos que el jugador
        for key in selectedCards.map({ $0.key }) {
            deck.removeValue(forKey: key)
        }

        let selectedCardsBot = Array(deck.shuffled().prefix(5))
        // Imprimir las cartas seleccionadas en la consola (opcional, solo para verificar)
        for (nombre, valor) in selectedCardsBot {
            print("La carta del bot: \(nombre) con un valor de \(valor).")

        }

        // Asignar las imágenes a las cinco cartas en pantalla
        let imageViewsBot = [cardBot1, cardBot2, cardBot3, cardBot4, cardBot5]
         
        for (index, cardbot) in selectedCardsBot.enumerated() {
            if index < imageViewsBot.count { // Asegurar que no exceda el número de `UIImageView`
                let imageName = "\(cardbot.key).png"
                imageViewsBot[index]?.image = UIImage(named: imageName)
             }
         }
        
        hightCardBot = selectedCardsBot.map { $0.value }.max() ?? 0
        print("oooa bot: \(hightCardBot)")
        // Función para verificar Escalera Color
        func isEscaleraColorBot(cards: [(key: String, value: Int)]) -> Bool {
            let palo = cards.first!.key.suffix(1) // Último carácter de la clave, que es el palo
            if !cards.allSatisfy({ $0.key.hasSuffix(String(palo)) }) {
                return false
            }
            
            let sortedCards = cards.sorted { $0.value < $1.value }
            
            for i in 0..<sortedCards.count-1 {
                if sortedCards[i].value + 1 != sortedCards[i + 1].value {
                    return false
                }
            }
            
            let asLow = ["AS", "2S", "3S", "4S", "5S"]
            let asHigh = ["TS", "JS", "QS", "KS", "AS"]
            if (cards.map { $0.key }.sorted() == asLow || cards.map { $0.key }.sorted() == asHigh) {
                return true
            }
            
            return true
        }

        
        // Función para verificar Four of a Kind del bot
        func cuatroIgualesBot(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 4 }  // Si hay un número con frecuencia 4
            
        }
        //funcion que se une con tresIguales para hacer un Color y tambien para validar si tiene Dos Iguales del bot.
        func dosIgualesBot(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 2 }  // Si hay un número con frecuencia 4
        }
        //funcion que se une con dosIguales para hacer un Color del bot

        func tresIgualesBot(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 3 }  // Si hay un número con frecuencia 4
        }
        //funcion para validar si tiene Escalera del bot
        func cincoIgualesBot(cards: [(key: String, value: Int)]) -> Bool {
            let palo = cards.first!.key.suffix(1) // Último carácter de la clave, que es el palo
            if !cards.allSatisfy({ $0.key.hasSuffix(String(palo)) }) {
                return false
            }
            return true
        }
        // funcion para validar si tiene Doble Par del bot
        func dobleParBot(cards: [(key: String, value: Int)]) -> Bool {
            // Contar la cantidad de veces que aparece cada valor
            var countValues: [Int: Int] = [:]

            for card in cards {
                countValues[card.value, default: 0] += 1
            }

            // Contar cuántos valores aparecen exactamente 2 veces del bot
            let pairs = countValues.values.filter { $0 == 2 }.count

            // Debe haber exactamente dos pares
            return pairs == 2
        }
        //funcion para validar si tiene AS del bot
        func tieneAsBot(cards: [(key: String, value: Int)]) -> Bool {
            return cards.contains { $0.key.hasPrefix("A") }
        }
        
        // Usar el switch para verificar la jugada y mostrar el resultado en pantalla
         switch true {
         case isEscaleraColorBot(cards: selectedCardsBot):
             labelConcien.text = "Me tocó Escalera Color... A ver cuánto me dura la suerte..."
             puntajeBot = 30

         case cuatroIgualesBot(cards: selectedCardsBot):
             labelBotConcien.text = "Interesante… Four of a Kind, algo me dice que esto no fue solo suerte."
             puntajeBot = 25

         case dosIgualesBot(cards: selectedCardsBot) && tresIguales(cards: selectedCards):
             labelBotConcien.text = "Color... cinco cartas del mismo palo, demasiada coincidencia... o tal vez el destino juega conmigo. "
             puntajeBot = 20

         case cincoIgualesBot(cards: selectedCardsBot):
             labelBotConcien.text = "Escalera... cinco cartas en orden secuencial, no sé si es suerte o una trampa bien armada..."
             puntajeBot = 15

         case tresIgualesBot(cards: selectedCardsBot):
             labelBotConcien.text = "Trío... tres cartas con el mismo valor, Una coincidencia… ¿o un patrón que se repite en la oscuridad? "
             puntajeBot = 10

         case dobleParBot(cards: selectedCardsBot):
             labelBotConcien.text = "Dos pares de cartas con el mismo valor, Curioso... dos reflejos en un mismo cristal. ¿Destino o simple azar?"
             puntajeBot = 5

         case dosIgualesBot(cards: selectedCardsBot):
             labelBotConcien.text = "Un par solitario, perdido en el mazo, no es mucho, pero suficiente para hacerte dudar. ¿Te conformas... o sigues apostando?"
             puntajeBot = 4

         case tieneAsBot(cards: selectedCardsBot):
             labelBotConcien.text = "Un As... No cambia el destino, no salva la partida. Solo está ahí... solo."
             puntajeBot = 4

         default:
             labelBotConcien.text = "Nada de lo que salió fue lo que esperaba, las cartas se mezclan, pero nunca es suficiente"
             puntajeBot = 0

         }
        print(puntajeBot)
        print(puntajeJugador)
        
        switch true{
        case puntajeJugador > puntajeBot:
        print("Gano jugador 1")
            labelGanador.text = "Gano conciencia"
            labelScoreBot.text = "Don Omar Score:  \(String(puntajeBot))"
            labelScoreJugador.text = "Your Score: \(String(puntajeJugador))"
            
        case puntajeJugador < puntajeBot:
        print("Gana Bot")
            labelScoreBot.text = "Don Omar Score:  \(String(puntajeBot))"
            labelScoreJugador.text = "Your Score: \(String(puntajeJugador))"
            labelGanador.text = "Gano Don Omar..."
            
        case puntajeBot == puntajeJugador:
        print("Misma jugada, veremos las demas cartas para definir el ganador: ")
            labelGanador.text = "Empate..."
            labelScoreBot.text = "Don Omar Score:  \(String(puntajeBot))"
            labelScoreJugador.text = "Your Score: \(String(puntajeJugador))"
            switch true{
            case hightCardBot > hightCardJugador:
            print("gano Don Omar")
            case hightCardBot < hightCardJugador:
            print("gano la conciencia")
            default: print("")
                
                let jugadorOrdenado = selectedCards.sorted { $0.value > $1.value }
                let botOrdenado = selectedCardsBot.sorted { $0.value > $1.value }

                // Comparar la carta más alta
                for i in 0..<5 {
                    if jugadorOrdenado[i].value > botOrdenado[i].value {
                        labelGanador.text = "Ganaste el desempate con \(jugadorOrdenado[i].key)"
                        
                    } else if botOrdenado[i].value > jugadorOrdenado[i].value {
                        labelGanador.text =  "Don Omar gana el desempate con \(botOrdenado[i].key)"
                    }
                }
                
            }
            

        default: print("")
        }
        
        
        
    }
}

