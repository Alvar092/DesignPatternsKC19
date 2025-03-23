import XCTest

@testable import DesignPatterns
// Mocks para simular los casos

private extension HeroModel {
    static let dummyObject = HeroModel(identifier: "1",
                                       name: "Test",
                                       description: "Test",
                                       photo: "Test",
                                       favorite: false)
}

private final class SuccessGetHeroDetailUseCase: GetHeroeDetailUseCaseProtocol {

    private let hero: HeroModel

        init(hero: HeroModel) {
            self.hero = hero
        }

    func run(heroName: String, completion: @escaping (Result<HeroModel, any Error>) -> Void) {
        completion(.success(hero))
    }
}

final class FailedGetHeroDetailUseCase: GetHeroeDetailUseCaseProtocol {
    func run(heroName: String, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        completion(.failure(APIErrorResponse.network("Server error")))
    }
}

// Estado inicial viewModel
final class HeroDetailViewModelTests: XCTestCase {
    func testInitialStateIsNotEmitted() {
        // Asegura que al inicializar el VM no se emite ningun estado de forma automatica
        // Y que el Binding solo se activa cuando llamamos a loadHero()
        
        // GIVEN
        let dummyObject = HeroModel(identifier: "1",
                                    name: "Test",
                                    description: "Test",
                                    photo: "Test",
                                    favorite: false)
        
        // WHEN
        let useCase = SuccessGetHeroDetailUseCase(hero: dummyObject)
        let sut = HeroDetailViewModel(useCase: useCase, heroName: "Test")
        
        
        var stateEmitted = false
        sut.onStateChanged.bind { _ in stateEmitted = true }
        
        // THEN
        XCTAssertFalse(stateEmitted, "El estado no debería emitirse antes de llamar a loadHero.")
    }
    
    func testWhenUseCaseSucceedsStateIsSuccessAndHeroIsSet() {
        // GIVEN
        
        // Verificamos que el estado pasa correctamente de loading a success
        // Que el heroe cargado en el viewModel es el esperado
        let expectedHero = HeroModel(
            identifier: "1",
            name: "Goku",
            description: "Saiyan legendario",
            photo: "goku.jpg",
            favorite: true
        )
        let useCase = SuccessGetHeroDetailUseCase(hero: expectedHero)
        let sut = HeroDetailViewModel(useCase: useCase, heroName: "Goku")
        
        let loadingExpectation = expectation(description: "Estado loading emitido")
        let successExpectation = expectation(description: "Estado success emitido")
        
        sut.onStateChanged.bind { state in
            switch state {
                // THEN
                
            case .loading:
                loadingExpectation.fulfill()
            case .success:
                XCTAssertEqual(sut.hero?.name, "Goku", "El héroe cargado debe coincidir con el esperado")
                successExpectation.fulfill()
            default: break
            }
        }
        // WHEN?
        sut.loadHero()
        wait(for: [loadingExpectation, successExpectation], timeout: 5)
    }
    
    func testWhenUseCaseFailsStateIsError() {
        // Es un caso de uso que siempre debe fallar
        // Se emite primero loading y luego error
        
        // GIVEN
        let useCase = FailedGetHeroDetailUseCase()
        let sut = HeroDetailViewModel(useCase: useCase, heroName: "Goku")
        
        let loadingExpectation = expectation(description: "Estado loading emitido")
        let errorExpectation = expectation(description: "Estado error emitido")
        
        // WHEN
        sut.onStateChanged.bind { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .error(let reason):
                XCTAssertEqual(reason, "Vaya vaya, no tengo datos... ", "El mensaje de error debería coincidir con el esperado")
                errorExpectation.fulfill()
            default: break
            }
        }
        
        sut.loadHero()
        
        // THEN
        wait(for: [loadingExpectation, errorExpectation], timeout: 5)
    }
    
    func testMultipleLoadHeroCallsOnlyTriggersOneSuccess() {
        // Si llamamos a loadHero() varias veces seguidas el heroe se actualiza correctamente
        
        // GIVEN
        let expectedHero = HeroModel(
            identifier: "1",
            name: "Goku",
            description: "Saiyan legendario",
            photo: "goku.jpg",
            favorite: true
        )
        let useCase = SuccessGetHeroDetailUseCase(hero: expectedHero)
        let sut = HeroDetailViewModel(useCase: useCase, heroName: "Goku")
        
        let loadingExpectation = expectation(description: "Estado loading emitido")
        loadingExpectation.expectedFulfillmentCount = 1  // Debe emitirse solo una vez
        
        let successExpectation = expectation(description: "Estado success emitido")
        successExpectation.expectedFulfillmentCount = 1  // Debe emitirse solo una vez
        
        // WHEN
        sut.onStateChanged.bind { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .success:
                XCTAssertEqual(sut.hero?.name, "Goku", "El héroe cargado debe ser Goku")
                successExpectation.fulfill()
            default: break
            }
        }
        
        sut.loadHero()
        sut.loadHero()
        sut.loadHero()
        
        // THEN: Solo debe emitirse un `.loading` y un `.success`
        wait(for: [loadingExpectation, successExpectation], timeout: 5)
    }
}

