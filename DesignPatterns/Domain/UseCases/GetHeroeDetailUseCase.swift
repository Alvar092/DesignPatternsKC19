import Foundation

// Funcionalidad para obtener los detalles del heroe mediante otra solicitud
protocol GetHeroeDetailUseCaseProtocol {
    func run(heroName: String, completion:@escaping (Result<HeroModel, Error>) -> Void)
}

 //Caso de uso para obtener el heroe desde la API
final class GetHeroDetailUseCase: GetHeroeDetailUseCaseProtocol {
    func run(heroName: String, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        GetHeroesAPIRequest(name: heroName)
            .perform { result in
                do  {
                    let heroes = try result.get()
                    let mapper = HeroDTOToHeroModelMapper()
                    
                    // Obtener el primer héroe que devuelva la API (debería ser único si filtra bien)
                    if let heroDTO = heroes.first {
                        let hero = mapper.map(heroDTO)
                        completion(.success(hero))
                    } else {
                        completion(.failure(NSError(domain: "HeroNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "No se encontró el héroe"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
