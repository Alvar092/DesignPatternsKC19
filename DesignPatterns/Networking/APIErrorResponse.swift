import Foundation

struct APIErrorResponse: Error, Equatable {
    let url: String
    let statusCode: Int
    let data: Data?
    let message: String
    
    init(url: String, statusCode: Int, data: Data? = nil, message: String) {
        self.url = url
        self.statusCode = statusCode
        self.data = data
        self.message = message
    }
}

extension APIErrorResponse {
    
    // URL mal hecha 
    static func malformedURL(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -5, message: "Malformed URL")
    }
    
    // fallo en la conexion de rede
    static func network(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -1, message: "Network connection error")
    }
    
    // La respuesta no se puede parsear
    static func parseData(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -2, message: "Cannot parse data from URL")
    }
    
    // no se que pasa
    static func unknown(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -3, message: "Unknown error")
    }
    
    // respuesta vacia
    static func empty(_ url: String) -> APIErrorResponse {
        return APIErrorResponse(url: url, statusCode: -4, message: "Empty data")
    }
}
