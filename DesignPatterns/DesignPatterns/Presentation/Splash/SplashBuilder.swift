import UIKit

// Crea una instancia de otro controlador. Crea una vista sin necesidad de saber que hay por debajo. 

final class SplashBuilder {
//    private var viewModel: SplashViewModel
//    
//    init() {
//        self.viewModel = SplashViewModel()
//    }
//    
//    func set(viewModel: SplashViewModel) -> Self {
//        self.viewModel = viewModel
//        return self
//    }
//    
    func build() -> UIViewController {
        let viewModel = SplashViewModel()
        return SplashViewController(viewModel: viewModel)
    }
}
