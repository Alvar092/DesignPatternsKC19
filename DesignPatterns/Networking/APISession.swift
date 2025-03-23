import Foundation

// Contrato para realizar solicitudes HTTP basado en un generico. Solicitud en request y callback en el completion.
protocol APISessionContract {
    func request<Request: HTTPRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

// Implementacion del protocolo
struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    // Sesion utilizada
    private let session: URLSession
    
    // Interceptores que modifican las solicitudes antes de enviarlas.
    private let requestInterceptors: [APIRequestInterceptor]
    
    // Inicializa una nueva instancia de APISession
    init(configuration: URLSessionConfiguration = .default,
         requestInterceptors: [APIRequestInterceptor] = [AuthenticationAPIInterceptor()]) {
        self.requestInterceptors = requestInterceptors
        self.session = URLSession(configuration: configuration)
    }
    
    func request<Request: HTTPRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            // Obtenemos la URL a partir de HTTPRequest
            var request = try apiRequest.getRequest()
            
            // Aplicamos interceptor
            requestInterceptors.forEach { request = $0.intercept(request) }
            session.dataTask(with: request) { data, response, error in
                if let error {
                    return completion(.failure(error))
                }
                
                // Verifica que la respuesta sea HTTPURLResponse
                guard let httpResponse = response as? HTTPURLResponse else {
                    return completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
                switch httpResponse.statusCode {
                case 200..<300:
                    // Exito! Se devuelve el Data obtenido
                    return completion(.success(data ?? Data()))
                default:
                    // Fail, gestionamos el error que se devuelve en APIErrorResponse
                    return completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
                
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
