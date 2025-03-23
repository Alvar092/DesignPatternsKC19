import Foundation

// Posibles estados de inicio de sesión
enum LoginState: Equatable {
    case success
    case loading
    case error(reason: String)
}

// LoginViewModel gestiona la logica de inicio de sesion y actualiza el estado de la vista. 
final class LoginViewModel {
    // Caso de uso que maneja la autenticaciín
    let useCase: LoginUseCaseProtocol
    
    // Binding que notifica de los cambios de estado durante el proceso.
    let onStateChanged = Binding<LoginState>()
    
    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }
    // Proceso de inicio de sesión
    func login(username: String?, password: String?) {
        onStateChanged.update(.loading)
        useCase.run(username: username ?? "", password: password ?? "") { [weak self] result in
            switch result {
            case .success:
                self?.onStateChanged.update(.success)
            case .failure(let error):
                self?.onStateChanged.update(.error(reason: error.reason))
            }
        }
    }
}
