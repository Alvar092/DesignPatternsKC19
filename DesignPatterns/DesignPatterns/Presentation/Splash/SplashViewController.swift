import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private let viewModel: SplashViewModel
    
    
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of:self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
    
    // MARK: - Binding
    // Te suscribes a los cambios de estado del viewModel, "se queda escuchando"
    private func bind() {
        viewModel.onStateChanged.bind { [ weak self] state in
            switch state {
            case .loading:
                self?.setAnimation(true)
            case .ready, .error:
                print("Finished")
                self?.setAnimation(false)
            }
        }
    }
    
    
    // MARK: - UI operations
    private func setAnimation(_ animating: Bool) {
        switch activityIndicator.isAnimating {
        case true where !animating:
            activityIndicator.stopAnimating()
        case false where animating:
            activityIndicator.startAnimating()
        default: break
        }
    }
}
    
#Preview {
    SplashBuilder().build()
}
