import Foundation

// Enum de states
enum HeroDetailState: Equatable {
    case loading
    case success
    case error(reason: String)
}


final class HeroDetailViewModel {
    private(set)var hero: HeroModel?
    
    // Para evitar llamadas multiples cuando estas probando la app en un blablacar con la cobertura cutre y un mac intel que va mas lento que el caballo del malo
    private var isLoading = false
    
    let onStateChanged = Binding<HeroDetailState>()
    
    // Caso de uso responsable de obtener el heroe de turno
    private let useCase: GetHeroeDetailUseCaseProtocol
    private let heroName: String
    
    // Recibir un HeroModel en su inicializador
    init( useCase: GetHeroeDetailUseCaseProtocol, heroName: String) {
        self.useCase = useCase
        self.heroName = heroName
    }
    
    // Realizar otra request porque no puedo reutilizar el heroe e.e
    func loadHero() {
        // Evitar las llamadas concurrentes
        guard !isLoading else { return }
        isLoading = true
        
        // Actualizar con caso de uso
        onStateChanged.update(.loading)
        useCase.run(heroName: heroName) { [weak self] result in
            DispatchQueue.main.async {
                // Defer para actualizar isLoading lo primero de todo
                defer { self?.isLoading = false }
                
                do {
                    let heroes = try result.get()
                    self?.hero = heroes
                    self?.onStateChanged.update(.success)
                } catch {
                    self?.onStateChanged.update(.error(reason: "Vaya vaya, no tengo datos..."))
                }
            }
        }
    }
}
