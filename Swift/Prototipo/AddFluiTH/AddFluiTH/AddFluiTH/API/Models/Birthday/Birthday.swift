import Foundation

struct Birthday: Identifiable, Decodable {
    let id: Int
    let name: String
    let date: Date
}
