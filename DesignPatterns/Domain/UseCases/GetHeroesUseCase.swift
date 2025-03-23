import Foundation

// Aqui la funcionalidad para obtener la lista de heroes.
// Devuelve un result con el array de HeroModel
protocol GetHeroesUseCaseProtocol {
    func run(completion: @escaping (Result<[HeroModel], Error>) -> Void)
}

// Caso de uso para obtener la lista de heroes desde la API  
final class GetHeroesUseCase: GetHeroesUseCaseProtocol {
    func run(completion: @escaping (Result<[HeroModel], Error>) -> Void) {
        GetHeroesAPIRequest()
            .perform { result in
                do {
                    let heroes = try result.get()
                    let mapper = HeroDTOToHeroModelMapper()
                    completion(.success(heroes.map { mapper.map($0) }))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
