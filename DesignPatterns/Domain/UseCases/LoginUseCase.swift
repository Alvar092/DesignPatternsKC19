import Foundation

struct LoginError: Error {
    let reason: String
}

// Para invertir la inyeccion de dependencias, con el protocolo dependemos
// de un comportamiento y no de un objeto (aunque se comporta igual, pero esto es como coger la llave y no al sereno).
protocol LoginUseCaseProtocol {
    // Ejecuta la autenticación con las credenciales
    func run(username: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void)
}

// Caso de uso para gestionar la autenticación del usuario
final class LoginUseCase: LoginUseCaseProtocol {
    private let dataSource: SessionDataSourceProtocol
    
    // inicializa el caso con un punto de origen de datos para iniciar la sesión.
    // Entiendo que aqui se guardaran los datos de primeras y se guardarían en persistencia mientras estamos en el ajo.
    init(dataSource: SessionDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    // Para un user y pass retorna un parametro 
    func run(username: String, password: String, completion: @escaping (Result<Void, LoginError>) -> Void) {
        guard isValidUsername(username) else {
            return completion(.failure(LoginError(reason: "El usuario no es válido")))
        }
        guard isValidPassword(password) else {
                return completion(.failure(LoginError(reason: "La contraseña no es válida")))
        }
        LoginAPIRequest(username: username, password: password)
            .perform { [weak self] response in
                switch response {
                case .success(let data):
                    self?.dataSource.storeSession(data)
                    completion(.success(()))
                case .failure:
                    completion(.failure(LoginError(reason: "Ha ocurrido un error en la red")))
                }
            }
    }
    
    private func isValidUsername(_ string: String) -> Bool {
        !string.isEmpty && string.contains("@")
    }
    
    private func isValidPassword(_ string: String) -> Bool {
        string.count >= 4
    }
}
