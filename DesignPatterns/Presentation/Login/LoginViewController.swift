import UIKit

// Controlador de la vista de la sesion. Maneja las entradas del usuario y los cambios de estado.
final class LoginViewController: UIViewController {
    // VM que gestiona la logica
    private let viewModel: LoginViewModel
    
    // La label de error la ocultamos mientras no haga falta
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loginButton: UIButton!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Binding
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // Observamos el estado del VM, cuando el estado cambie,
    // este se evalua y se llama al metodo apropiado al estado que sea.
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .error(let reason): self?.renderError(reason)
            case .loading: self?.renderLoading()
            case .success: self?.renderSuccess()
            }
        }
    }
    
    // MARK: - Events
    // Esto envia las credenciales al VM cuando ha pulsado el boton
    @IBAction func onButtonTapped(_ sender: Any) {
        viewModel.login(username: usernameField.text, password: passwordField.text)
    }
    
    // MARK: - State management
    // Muestra la pantalla de heroes tras la autenticación exitosa
    private func renderSuccess() {
        activityIndicator.stopAnimating()
        loginButton.isHidden = false
        errorLabel.isHidden = true
        present(HeroesListBuilder().build(), animated: true)
    }
    
    // Muestra el indiciador de carga mientras se procesa la autenticación
    private func renderLoading() {
        activityIndicator.startAnimating()
        loginButton.isHidden = true
        errorLabel.isHidden = true
    }
    
    // Fallo de autenticación¿?
    private func renderError(_ message: String) {
        activityIndicator.stopAnimating()
        loginButton.isHidden = false
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}

#Preview {
    LoginBuilder().build()
}
