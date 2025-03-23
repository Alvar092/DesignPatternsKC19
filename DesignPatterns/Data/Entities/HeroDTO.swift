// Representación de los datos tal y como llegan de la API en formato JSON

struct HeroDTO: Codable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case photo
        case favorite
    }
}
