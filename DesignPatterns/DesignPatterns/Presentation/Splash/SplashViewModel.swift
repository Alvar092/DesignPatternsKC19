import Foundation

// Definimos los estados para transmitir los eventos. Transmite la situación que tiene la vista.
enum SplashState: Equatable {
    case loading
    
    case error
    
    case ready
}

// Dos flujos, uno de enviar peticiones y otro de enviar los cambios de estado. load() es el flujo de entrada.
// Te pones a cargar y haces cosas por debajo.
// El flujo de salida es el binding

final class SplashViewModel {
    var onStateChanged = Binding<SplashState>()
    
    func load() {
        onStateChanged.update(.loading)
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.onStateChanged.update(.ready)
            }
        }
    }
