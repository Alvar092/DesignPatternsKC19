import Foundation

// Solicitud para obtener el listado de heroes
struct GetHeroesAPIRequest: HTTPRequest {
    // Lo que se espera
    typealias Response = [HeroDTO]
    
    // Metodo para la solicitud, ruta de la API y cuerpo de la solicitud
    let method: Methods = .POST
    let path: String = "/api/heros/all"
    let body: (any Encodable)?
    
    // Inicializamos la solicitud con un nombre opcional para filtrar heroes.
    init(name: String = "") {
        body = RequestDTO(name: name)
    }
}

// Ese nombre opcional se configura aqui
private extension GetHeroesAPIRequest {
    struct RequestDTO: Codable {
        let name: String
    }
}
