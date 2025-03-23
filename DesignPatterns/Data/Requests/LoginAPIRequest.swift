import Foundation

// Representa la solcitidu HTTP para autenticación en la API.
struct LoginAPIRequest: HTTPRequest {
    typealias Response = Data
    
    // Encabezado, metodo y ruta
    let headers: [String: String]
    let method: Methods = .POST
    let path: String = "/api/auth/login"
    
    // Inicializa la solicitud de la API con usuario y contraseña.
    init(username: String, password: String) {
        let loginData = Data(String(format: "%@:%@", username, password).utf8)
        let base64LoginData = loginData.base64EncodedString()
        headers = ["Authorization": "Basic \(base64LoginData)"]
    }
}
