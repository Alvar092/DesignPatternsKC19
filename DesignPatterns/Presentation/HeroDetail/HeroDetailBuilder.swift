import UIKit

// Instanciar la pantalla de detalle con su VM
final class HeroDetailBuilder {
    func build(hero: HeroModel) -> UIViewController {
        // Caso de uso con el que obtenemos el heroe
        let useCase = GetHeroDetailUseCase()
        // VM con el que manejaremos la logica de presentacion
        // Aqui es donde es clave que al seleccionar la celda, selectedHero da el heroName
        let viewModel = HeroDetailViewModel(useCase: useCase, heroName: hero.name)
        let controller = HeroDetailViewController(viewModel: viewModel, heroName: hero.name)
        controller.modalPresentationStyle = .fullScreen
        return controller
    }
}

