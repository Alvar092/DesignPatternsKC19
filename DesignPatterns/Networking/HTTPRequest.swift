import Foundation

// Definimos los requisitos para realizar una solicitud HTTP
protocol HTTPRequest {
    associatedtype Response: Decodable

    // Encapsula el resultado de la operacion
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    
    // Closure que maneja el resultado de la operacion
    typealias APIRequestCompletion = (APIRequestResponse) -> Void
    
    // El metodo de la solicitud (.POST, .GET, etc)
    var method: Methods { get }
    // Host del servidor
    var host: String { get }
    // Ruta específica de la solicitud
    var path: String { get }
    // Parametros de la url en formato clave:valor
    var queryParameters: [String: String] { get }
    // Encabezados http adicionales
    var headers: [String: String] { get }
    // Cuerpo de la solicitud, si procede
    var body: Encodable? { get }
}

extension HTTPRequest {
    var host: String { "dragonball.keepcoding.education" }
    var queryParameters: [String: String] { [:] }
    var headers: [String: String] { [:] }
    var body: Encodable? { nil }
    
    // Construye y devuelve el URLRequest. Throws para devolver un error si la URL no es valida o no decodifica bien.
    func getRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        // Verifica url valida
        guard let url = components.url else {
            fatalError("Invalid URLComponents")
        }
        
        // Crea peticion
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Si la solicitud tiene cuerpo y no es GET, lo codifica a JSON
        if let body, method != .GET {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // Tiempo de espera y los encabezados HTTP
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["Accept": "application/json", "Content-Type": "application/json"]
            .merging(headers) { $1 }
        return request
    }
    
    // Ejecuta la peticion HTTP usando una sesion de red
    func perform(session: APISessionContract = APISession.shared, completion: @escaping APIRequestCompletion) {
        session.request(apiRequest: self) { result in
            do {
                let data = try result.get()
                // Manejo de respuestas tanto para void como para Data
                if Response.self == Void.self {
                    return completion(.success(() as! Response))
                } else if Response.self == Data.self {
                    return completion(.success(data as! Response))
                }
                // Decodifica el JSON con el tipo esperado
                return try completion(.success(JSONDecoder().decode(Response.self, from: data)))
            } catch let error as APIErrorResponse {
                completion(.failure(error))
            } catch let error as DecodingError {
                completion(.failure(APIErrorResponse.parseData(path)))
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))
            }
        }
    }
}
