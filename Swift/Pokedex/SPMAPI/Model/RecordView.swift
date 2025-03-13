import UIKit
import Alamofire
import Kingfisher

class RecordView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var pokemonTypes: [String] = []
    var pokemonByType: [String: [Pokemon]] = [:]
    var expandedSections: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registrar la celda personalizada
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        
        fetchPokemonTypes()
    }
    
    func fetchPokemonTypes() {
        let url = "https://pokeapi.co/api/v2/type?limit=5"
        
        AF.request(url).responseDecodable(of: PokemonTypeList.self) { response in
            switch response.result {
            case .success(let typeList):
                self.pokemonTypes = typeList.results.map { $0.name }
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching Pokemon types: \(error)")
            }
        }
    }
    
    func fetchPokemonByType(type: String, section: Int) {
        let url = "https://pokeapi.co/api/v2/type/\(type)"
        
        AF.request(url).responseDecodable(of: PokemonTypeDetail.self) { response in
            switch response.result {
            case .success(let typeDetail):
                let pokemonNames = typeDetail.pokemon.map { $0.pokemon.name }
                self.fetchPokemonDetails(pokemonNames: pokemonNames, type: type, section: section)
                
            case .failure(let error):
                print("Error fetching Pokemon by type: \(error)")
            }
        }
    }
    
    func fetchPokemonDetails(pokemonNames: [String], type: String, section: Int) {
        var pokemonList: [Pokemon] = []
        let group = DispatchGroup()
        
        for name in pokemonNames {
            group.enter()
            let url = "https://pokeapi.co/api/v2/pokemon/\(name)"
            
            AF.request(url).responseDecodable(of: Pokemon.self) { response in
                switch response.result {
                case .success(let pokemon):
                    pokemonList.append(pokemon)
                case .failure(let error):
                    print("Error fetching Pokemon details: \(error)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.pokemonByType[type] = pokemonList
            self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
}

extension RecordView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pokemonTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = pokemonTypes[section]
        return expandedSections.contains(section) ? (pokemonByType[type]?.count ?? 0) + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath)
            cell.textLabel?.text = pokemonTypes[indexPath.section]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
            let type = pokemonTypes[indexPath.section]
            
            if let pokemon = pokemonByType[type]?[indexPath.row - 1] {
                cell.nameLabel.text = pokemon.name.capitalized
                
                // Cargar la imagen del Pokémon usando Kingfisher
                if let imageUrl = URL(string: pokemon.sprites.frontDefault ?? "") {
                    cell.pokemonImageView.kf.setImage(with: imageUrl)
                } else {
                    cell.pokemonImageView.image = nil
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44 // Altura para la celda de tipo
        } else {
            return 60 // Altura para la celda de Pokémon
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let section = indexPath.section
            let type = pokemonTypes[section]
            
            if expandedSections.contains(section) {
                expandedSections.remove(section)
            } else {
                expandedSections.insert(section)
                if pokemonByType[type] == nil {
                    fetchPokemonByType(type: type, section: section)
                }
            }
            
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
}
