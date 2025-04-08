struct LoginRequest: Codable {
    let usuario: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

