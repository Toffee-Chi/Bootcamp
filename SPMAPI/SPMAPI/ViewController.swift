import UIKit
import Foundation
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var habilidad: UILabel!    // Ahora mostrará la habilidad especial
    @IBOutlet weak var peso: UILabel!  // Ahora mostrará el peso
    @IBOutlet weak var tipo: UILabel!  // Ahora mostrará el tipo de Pokémon
    
    @IBOutlet weak var nombrePokemon: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var image1: UIImageView!
    
    
    let pickerView = UIPickerView()
    let opciones = ["Nombre", "ID"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroundMusic.shared.play()
    }
    
    @IBAction func buscarPokemon(_ sender: UIButton) {
        guard let nombrePokemon = nombrePokemon.text?.lowercased(), !nombrePokemon.isEmpty else {
            titulo.text = "Introduce un nombre"
            return
        }
        
        let url = "https://pokeapi.co/api/v2/pokemon/\(nombrePokemon)"
        
        /*HTTPClient.request(endpoint: url,
         method: .get,
         encoding: .json) { response in
         
         }, headers: { error in
         
         }*/
        //        HTTPClient.request(endpoint: url,
        //                           onSuccess: { _ in
        //        })
        //
        AF.request(url).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    self.titulo.text = "Nombre: \(pokemon.name.capitalized)"
                    
                    // Mostrar habilidad especial
                    if let habilidadEspecial = pokemon.abilities.first?.ability.name {
                        self.habilidad.text = "Habilidad: \(habilidadEspecial.capitalized)"
                    } else {
                        self.habilidad.text = "Habilidad: No disponible"
                    }
                    
                    // Mostrar peso del Pokémon
                    self.peso.text = "Peso: \(pokemon.weight / 10) kg" // API devuelve en hectogramos
                    
                    //  Mostrar tipo de Pokémon
                    if let tipo = pokemon.types.first?.type.name {
                        self.tipo.text = "Tipo: \(tipo.capitalized)"
                    } else {
                        self.tipo.text = "Tipo: No disponible"
                    }
                    
                    // Cargar imagen con Kingfisher
                    if let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png") {
                        self.image1.kf.setImage(with: imageUrl)
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self.titulo.text = "Error: No encontrado"
                    self.habilidad.text = "Habilidad: -"
                    self.peso.text = "Peso: -"
                    self.tipo.text = "Tipo: -"
                }
            }
        }
    }
}

//  Modelo  con habilidades, peso y tipos
struct Pokemon: Decodable {
    let name: String
    let id: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let types: [PokemonType]
}

struct PokemonAbility: Decodable {
    let ability: AbilityInfo
}

struct AbilityInfo: Decodable {
    let name: String
}

struct PokemonType: Decodable {
    let type: TypeInfo
}

struct TypeInfo: Decodable {
    let name: String
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Número de columnas en el Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Número de filas (opciones)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return opciones.count
    }
    
    // Título de cada fila
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return opciones[row]
    }
    
    // Capturar la opción seleccionada
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Seleccionaste: \(opciones[row])")
    }
}
