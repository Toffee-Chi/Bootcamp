import UIKit
import Alamofire

// Estructura para el Pokémon
struct Pokemon: Decodable {
    let name: String
    let id: Int
    let weight: Int
    let abilities: [PokemonAbility]
    let types: [PokemonType]
    let sprites: Sprites
    let species: PokemonSpeciesReference
}

// Estructura para la habilidad de Pokémon
struct PokemonAbility: Decodable {
    let ability: AbilityInfo
}

// Información de la habilidad
struct AbilityInfo: Decodable {
    let name: String
}

// Estructura para los tipos de Pokémon
struct PokemonType: Decodable {
    let type: TypeInfo
}

// Información de los tipos de Pokémon
struct TypeInfo: Decodable {
    let name: String
}

// Estructura para las imágenes retro de los Pokémon
struct Sprites: Decodable {
    let frontDefault: String?
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// Estructura para la lista de Pokémon
struct PokemonList: Decodable {
    let results: [PokemonResult]
}

// Estructura para un Pokémon específico en la lista
struct PokemonResult: Decodable {
    let name: String
}

// Estructura para obtener los tipos de Pokémon
struct PokemonTypeList: Decodable {
    let results: [TypeInfo]
}

// Estructura para obtener los Pokémon por tipo
struct PokemonTypeDetail: Decodable {
    let pokemon: [PokemonEntry]
}

// Estructura para los Pokémon en la lista por tipo
struct PokemonEntry: Decodable {
    let pokemon: PokemonBasicInfo
}

// Información básica del Pokémon
struct PokemonBasicInfo: Decodable {
    let name: String
}

// Estructura para obtener la biografía (descripción) del Pokémon
struct PokemonSpeciesReference: Decodable {
    let url: String
}

struct PokemonSpecies: Decodable {
    let flavorTextEntries: [FlavorTextEntry]
}

struct FlavorTextEntry: Decodable {
    let flavorText: String
    let language: Language
}

struct Language: Decodable {
    let name: String
}
