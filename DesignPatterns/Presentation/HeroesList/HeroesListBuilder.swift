import UIKit

// Se encarga de inyectar las dependencias y devolver un HeroListViewController listo para presentar.
final class HeroesListBuilder {
    func build() -> UIViewController {
        // Caso de uso del que obtenemos la lista de heroes
        let useCase = GetHeroesUseCase()
        // VM que maneja la logica de presentacion
        let viewModel = HeroesListViewModel(useCase: useCase)
        let rootViewController = HeroesListViewController(viewModel: viewModel)
        let controller = UINavigationController(rootViewController: rootViewController)
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}
