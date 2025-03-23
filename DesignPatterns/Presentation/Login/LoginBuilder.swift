import UIKit

// Este Construye y configura el modulo de Login
// Ensambla las dependencias necesarias y devuelve un UIViewController listo para su presentacion
final class LoginBuilder {
    func build() -> UIViewController {
        let useCase = LoginUseCase(dataSource: SessionDataSource.shared)
        let viewModel = LoginViewModel(useCase: useCase)
        let controller = LoginViewController(viewModel: viewModel)
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}
