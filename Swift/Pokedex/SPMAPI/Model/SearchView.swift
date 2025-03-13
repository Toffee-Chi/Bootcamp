import UIKit
import Alamofire
import Kingfisher

class SearchView: UIViewController{
    @IBOutlet weak var textFieldTipos: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchPokemon: UISearchBar!
    
    // Variables para el picker
    let pickerView = UIPickerView()
    let opciones = ["Nombre", "Tipo"]
    var criterioSeleccionado = "Nombre"
    var tiposPokemon: [String] = []
    
    var tipoSeleccionado: String? = nil  // Almacena el tipo seleccionado
    
    var pokemones: [(name: String, imageUrl: String)] = []
    var filteredPokemones: [(name: String, imageUrl: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar PickerView para seleccionar el criterio de búsqueda
        pickerView.delegate = self
        pickerView.dataSource = self
        textFieldTipos.inputView = pickerView
        textFieldTipos.text = "Seleccionar Tipo"
        
        // Configurar SearchBar
        searchPokemon.delegate = self
        
        // Configurar TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        
        // Llamadas para obtener la información de Pokémon y tipos
        fetchAllPokemon()  // Obtiene la lista de Pokémon
        fetchPokemonTypes() // Obtiene los tipos de Pokémon desde la API
    }
    
    
    func fetchAllPokemon() {
        let url = "https://pokeapi.co/api/v2/pokemon?limit=802"
        
        AF.request(url).responseDecodable(of: PokemonList.self) { response in
            switch response.result {
            case .success(let pokemonList):
                let group = DispatchGroup()
                var tempPokemones: [(name: String, imageUrl: String)] = []
                
                for result in pokemonList.results {
                    group.enter()
                    self.fetchPokemonImage(for: result.name) { imageUrl in
                        tempPokemones.append((name: result.name, imageUrl: imageUrl))
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.pokemones = tempPokemones
                    self.filteredPokemones = self.pokemones
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print("Error al obtener la lista de Pokémon: \(error)")
            }
        }
    }
    
    func fetchPokemonTypes() {
        let url = "https://pokeapi.co/api/v2/type"
        
        AF.request(url).responseDecodable(of: PokemonTypeList.self) { response in
            switch response.result {
            case .success(let typeList):
                self.tiposPokemon = typeList.results.map { $0.name.capitalized }
                self.pickerView.reloadAllComponents() // Actualiza el PickerView con los tipos obtenidos
            case .failure(let error):
                print("Error al obtener los tipos: \(error)")
            }
        }
    }
    
    func filterByType(tipo: String) {
        let url = "https://pokeapi.co/api/v2/type/\(tipo)"
        
        AF.request(url).responseDecodable(of: PokemonTypeDetail.self) { response in
            switch response.result {
            case .success(let typeData):
                let pokemonNames = typeData.pokemon.map { $0.pokemon.name }
                self.filteredPokemones = self.pokemones.filter { pokemonNames.contains($0.name) }
                self.applySearchFilter()  // Aplica el filtro de búsqueda después de filtrar por tipo
                self.tableView.reloadData()
            case .failure(let error):
                print("Error al filtrar por tipo: \(error)")
            }
        }
    }
    
    // Aplica el filtro de búsqueda de nombre (SearchBar)
    func applySearchFilter() {
        if let searchText = searchPokemon.text, !searchText.isEmpty {
            filteredPokemones = filteredPokemones.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func fetchPokemonImage(for name: String, completion: @escaping (String) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon/\(name)"
        
        AF.request(url).responseDecodable(of: Pokemon.self) { response in
            switch response.result {
            case .success(let pokemon):
                completion(pokemon.sprites.frontDefault ?? "")
            case .failure:
                completion("")
            }
        }
    }
}


extension SearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applySearchFilter()  // Aplica el filtro de búsqueda por nombre
        
        // Recarga la tabla
        tableView.reloadData()
    }
}

// Extensión del picker, para seleccionar tipos
extension SearchView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tiposPokemon.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tiposPokemon[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tipoSeleccionado = tiposPokemon[row]
        textFieldTipos.text = tipoSeleccionado
        textFieldTipos.resignFirstResponder()
        
        self.tipoSeleccionado = tipoSeleccionado.lowercased()  // Guarda el tipo seleccionado
        filterByType(tipo: tipoSeleccionado.lowercased()) // Filtra los Pokémon por el tipo
    }
}


// Extensión para el TableView, maneja la vista de celdas
// Extensión para el TableView, maneja la vista de celdas
extension SearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPokemones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        let pokemon = filteredPokemones[indexPath.row]
        
        cell.nameLabel.text = pokemon.name.capitalized
        if let url = URL(string: pokemon.imageUrl) {
            cell.pokemonImageView.kf.setImage(with: url)
        } else {
            cell.pokemonImageView.image = nil
        }
        
        return cell
    }
    
    
    
    // MÉTODO PARA DETECTAR LA SELECCIÓN Y NAVEGAR A BiographyView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPokemon = filteredPokemones[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let biographyVC = storyboard.instantiateViewController(withIdentifier: "BiographyView") as? BiographyView {
            biographyVC.pokemonName = selectedPokemon.name
            biographyVC.pokemonImageUrl = selectedPokemon.imageUrl
            // Presentar el view controller en lugar de hacer push
            biographyVC.modalPresentationStyle = .fullScreen
            present(biographyVC, animated: true, completion: nil)
        } else {
            print("Error: No se pudo instanciar BiographyView desde el Storyboard")
        }
    }
    
    
}


// Celda personalizada para mostrar la imagen y el nombre del Pokémon
class PokemonCell: UITableViewCell {
    let pokemonImageView = UIImageView()
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        pokemonImageView.contentMode = .scaleAspectFit
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pokemonImageView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pokemonImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 50),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
