import UIKit

class PokerGame: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var card1Image: UIImageView!
    @IBOutlet weak var card2Image: UIImageView!
    @IBOutlet weak var card3Image: UIImageView!
    @IBOutlet weak var card4Image: UIImageView!
    @IBOutlet weak var card5Image: UIImageView!
    @IBOutlet weak var labelConcien: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func randomCarts(_ sender: Any) {
        let spades: [String: Int] = ["AS": 1, "2S": 2, "3S": 3, "4S": 4, "5S": 5, "6S": 6, "7S": 7, "8S": 8, "9S": 9, "TS": 10, "JS": 11, "QS": 12, "KS": 13]
        let clubs: [String: Int] = ["AC": 1, "2C": 2, "3C": 3, "4C": 4, "5C": 5, "6C": 6, "7C": 7, "8C": 8, "9C": 9, "TC": 10, "JC": 11, "QC": 12, "KC": 13]
        let hearts: [String: Int] = ["AH": 1, "2H": 2, "3H": 3, "4H": 4, "5H": 5, "6H": 6, "7H": 7, "8H": 8, "9H": 9, "TH": 10, "JH": 11, "QH": 12, "KH": 13]
        let diamonds: [String: Int] = ["AD": 1, "2D": 2, "3D": 3, "4D": 4, "5D": 5, "6D": 6, "7D": 7, "8D": 8, "9D": 9, "TD": 10, "JD": 11, "QD": 12, "KD": 13]

        // Unir todos los diccionarios en un solo mazo
        let deck = spades.merging(clubs) { _, new in new }
                      .merging(hearts) { _, new in new }
                      .merging(diamonds) { _, new in new }

        // Mezclar las cartas y tomar 5 sin repetir
        let selectedCards = Array(deck.shuffled().prefix(5))

        // Imprimir las cartas seleccionadas en la consola (opcional, solo para verificar)
        for (nombre, valor) in selectedCards {
            print("La carta seleccionada es \(nombre) con un valor de \(valor).")
        }
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

        // Función para verificar Four of a Kind (Poker)
        func cuatroIguales(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 4 }  // Si hay un número con frecuencia 4
        }
        
        func dosIguales(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 2 }  // Si hay un número con frecuencia 4
        }
        func tresIguales(cards: [(key: String, value: Int)]) -> Bool {
            let valores = cards.map { $0.value }
            let frecuencia = Dictionary(grouping: valores, by: { $0 }).mapValues { $0.count }
            
            return frecuencia.contains { $0.value == 3 }  // Si hay un número con frecuencia 4
        }
        func cincoIguales(cards: [(key: String, value: Int)]) -> Bool {
            let palo = cards.first!.key.suffix(1) // Último carácter de la clave, que es el palo
            if !cards.allSatisfy({ $0.key.hasSuffix(String(palo)) }) {
                return false
            }
            return true
        }
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
        func tieneAs(cards: [(key: String, value: Int)]) -> Bool {
            return cards.contains { $0.key.hasPrefix("A") }
        }

        
       // Usar el switch para verificar la jugada y mostrar el resultado en pantalla
        switch true {
        case isEscaleraColor(cards: selectedCards):
            labelConcien.text = "¡Escalera Color! Las cartas son \(selectedCards.map { $0.key })"
        
        case cuatroIguales(cards: selectedCards):
            labelConcien.text = "¡Poker (Four of a Kind)! Las cartas son \(selectedCards.map { $0.key })"
        case dosIguales(cards: selectedCards) && tresIguales(cards: selectedCards):
            labelConcien.text = "¡COLOR Las cartas son \(selectedCards.map { $0.key })"
        case cincoIguales(cards: selectedCards):
            labelConcien.text = "Hiciste una escalera: \(selectedCards.map { $0.key })"
        case tresIguales(cards: selectedCards):
            labelConcien.text = "Hiciste un trio: \(selectedCards.map { $0.key })"
        case doblePar(cards: selectedCards):
            labelConcien.text = "Hiciste un Doble Par: \(selectedCards.map { $0.key })"
        case dosIguales(cards: selectedCards):
            labelConcien.text = "Hiciste un Doble: \(selectedCards.map { $0.key })"
        case tieneAs(cards: selectedCards):
            labelConcien.text = "Tienes un As: \(selectedCards.map { $0.key })"
        default:
            labelConcien.text = "Mala suerte, no generaste ninguna buena jugada."
        }
    }
}

