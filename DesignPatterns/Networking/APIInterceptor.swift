import Foundation

protocol APIInterceptor { /* Common protocol for Request and response interceptors */ }

// Permite modifiar una URL antes de enviarla
protocol APIRequestInterceptor: APIInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}

// Agrega el token de sesión a la solicitud HTTP

final class AuthenticationAPIInterceptor: APIRequestInterceptor {
    // Fuente de datos que porporciona la sesion del protocolo
    private let dataSource: SessionDataSourceProtocol
    
    // Inicializa la fuente de datos para recuperar el token de sesion?
    init(dataSource: SessionDataSourceProtocol = SessionDataSource.shared) {
        self.dataSource = dataSource
    }
    
    // Intercepta y añade token
    func intercept(_ request: URLRequest) -> URLRequest {
        guard let session = dataSource.getSession() else {
            return request
        }
        var copy = request
        copy.setValue("Bearer \(String(decoding: session, as: UTF8.self))", forHTTPHeaderField: "Authorization")
        return copy
    }
}
