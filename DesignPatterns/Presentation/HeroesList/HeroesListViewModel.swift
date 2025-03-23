import Foundation

// Posible estados de la lista de heroes
enum HeroesListState: Equatable {
    case error(reason: String)
    case loading
    case success
}

// Gestiona la logica de la pantalla de la lista de heroes
// Se comunica con el caso de uso para obtener los datos y actualizar el estado de la vista.
final class HeroesListViewModel {
    
    // Binding que notifica los cambiosd de estasdo a la vista
    let onStateChanged = Binding<HeroesListState>()
    
    // Caso de uso responsable de obtener la lista de heroes
    private let useCase: GetHeroesUseCaseProtocol
    
    // Lista de heroes desde la API
    // Private(set) 
    private(set) var heroes: [HeroModel] = []
    
    init(useCase: GetHeroesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // inicializa los heroes desde el caso de uso y actualiza el estado
    func loadHeroes() {
        onStateChanged.update(.loading)
        useCase.run { [weak self] result in
//            switch result {
//            case .success(let heroes):
//                self?.heroes = heroes
//                self?.onStateChanged.update(.success)
//            case .failure:
//                self?.onStateChanged.update(.error(reason: "Oh no!! no tengo datos!"))
//            }
            do {
                self?.heroes = try result.get()
                self?.onStateChanged.update(.success)
            } catch {
                self?.onStateChanged.update(.error(reason: "Oh no!! no tengo datos!"))
            }
        }
    }
}
