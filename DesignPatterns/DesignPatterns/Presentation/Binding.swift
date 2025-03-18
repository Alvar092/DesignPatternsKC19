import Foundation

final class Binding<T: Equatable> /* where T: Equatable */ {
    typealias Completion = (T) -> Void
    
    // Hacer el binding reusable para todas las pantallas.
    private var completion: Completion?
    
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    // Si no esta en el hilo principal te lleva a el, y si esta, ejecuta el completion.
    func update(_ state: T) {
        if Thread.current.isMainThread {
            completion?(state)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.completion?(state)
            }
        }
    }
}
