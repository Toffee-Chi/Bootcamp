import UIKit
import Alamofire
import Kingfisher

class BiographyView: UIViewController {
    
    var pokemonName: String?
    var pokemonImageUrl: String?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemoTipo: UILabel!
    @IBOutlet weak var pokemonBiografia: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configura la vista con los datos del Pokémon
        if let name = pokemonName {
            nameLabel.text = name
            fetchPokemonData(pokemonName: name) { [weak self] pokemon, description in
                guard let self = self else { return }
                
                if let pokemon = pokemon {
                    self.pokemoTipo.text = "Tipo: \(pokemon.types.first?.type.name.capitalized ?? "No disponible")"
                }
                self.pokemonBiografia.text = description ?? "Descripción no disponible"
            }
        }
        
        if let imageUrlString = pokemonImageUrl, let imageUrl = URL(string: imageUrlString) {
            pokemonImageView.kf.setImage(with: imageUrl)
        }
    }
    
    // Función para obtener los detalles del Pokémon, incluyendo su tipo y biografía
    func fetchPokemonData(pokemonName: String, completion: @escaping (Pokemon?, String?) -> Void) {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/\(pokemonName.lowercased())"
        
        AF.request(endpoint).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let pokemon):
                // Obtener la biografía del Pokémon usando la URL de la especie
                self.fetchPokemonDescription(speciesURL: pokemon.species.url) { description in
                    // Asegúrate de actualizar la UI en el hilo principal
                    DispatchQueue.main.async {
                        // Actualiza el tipo
                        self.pokemoTipo.text = "Tipo: \(pokemon.types.first?.type.name.capitalized ?? "No disponible")"
                        
                        // Actualiza la biografía
                        self.pokemonBiografia.text = description ?? "Descripción no disponible"
                    }
                    completion(pokemon, description)
                }
                
            case .failure(let error):
                print("Error al obtener los datos del Pokémon: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }
    }

    // Obtiene la descripción del Pokémon desde la URL de su especie
    // Obtiene la descripción del Pokémon desde la URL de su especie
    func fetchPokemonDescription(speciesURL: String, completion: @escaping (String?) -> Void) {
        AF.request(speciesURL).responseDecodable(of: PokemonSpecies.self) { response in
            switch response.result {
            case .success(let speciesData):
                // Busca la descripción en español
                let descriptionEntry = speciesData.flavorTextEntries.first(where: { $0.language.name == "es" }) ??
                                       speciesData.flavorTextEntries.first
                
                // Si no se encuentra una descripción en español, seleccionamos la primera disponible
                var description = descriptionEntry?.flavorText ?? "Descripción no disponible"
                
                // Reemplaza caracteres no deseados (salto de línea, tabulación)
                description = description.replacingOccurrences(of: "\\n", with: " ")
                                         .replacingOccurrences(of: "\\f", with: " ")
                
                // Actualiza la interfaz en el hilo principal
                DispatchQueue.main.async {
                    self.pokemonBiografia.text = description
                }

                completion(description)

            case .failure(let error):
                print("Error al obtener la biografía del Pokémon, no se pudo xd: \(error.localizedDescription)")
                completion("Error al cargar la biografía")
            }
        }
    }


}
