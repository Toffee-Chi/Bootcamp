import UIKit

//Modelo Pokémon con habilidades, peso y tipos
struct Pokemon: Decodable {
    let name: String
    let id: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let types: [PokemonType]
    let sprites: Sprites
}
//almacena habilidad
struct PokemonAbility: Decodable {
    let ability: AbilityInfo
}
//la informacion de la habilidad
struct AbilityInfo: Decodable {
    let name: String
}
//representa el tipo de pokemon "agua,fuego,veneno, etc"
struct PokemonType: Decodable {
    let type: TypeInfo
}
//se ve el tipo de dato y el dato del pokemon
struct TypeInfo: Decodable {
    let name: String
}
//para la imagen retro
struct Sprites: Decodable {
    let frontDefault: String? // Este es el sprite por defecto
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default" // Mapeo al campo "front_default" de la API
    }
    
}
//arreglo de tipo pokemonresult, contiene el nombre de los pokemones
struct PokemonList: Decodable {
    let results: [PokemonResult]
}
//este contiene el nombre del pokemon
struct PokemonResult: Decodable {
    let name: String
}

// Modelo para obtener la lista de tipos de Pokémon desde la API
struct PokemonTypeList: Decodable {
    let results: [TypeInfo]
}

// Modelo para obtener la lista de Pokémon por tipo
struct PokemonTypeDetail: Decodable {
    let pokemon: [PokemonEntry]
}
// es donde esta la informacion basica del pokemon, es como una entrada a una lista mas grande
struct PokemonEntry: Decodable {
    let pokemon: PokemonBasicInfo
}
//esto solo contiene una propiedad name, por ej devuelve pikachu
struct PokemonBasicInfo: Decodable {
    let name: String
}
