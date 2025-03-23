import UIKit

// Para presentar el listado de heroes. Delegate y DAtaSource para manejar la presentación de los datos.
class HeroesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorStackView: UIStackView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // El VM que gestiona la lógica de la lista de heroes
    private let viewModel: HeroesListViewModel
    
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.loadHeroes()
        
        // Configuración de la tabla
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HeroCell", bundle: Bundle(for: type(of: self))),
                           forCellReuseIdentifier: HeroCell.reuseIdentifier)
    }
    
    // Se ejecuta al tocar el boton de reintentar el error.
    @IBAction func onRetryButtonTapped(_ sender: Any) {
        viewModel.loadHeroes()
    }
    
    // MARK: - Binding
    // Enlaza el estado del VM con la vista para reaccionar a los cambios de estado
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .error(let reason):
                self?.renderError(reason)
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            }
        }
    }
    
    // MARK: - State rendering
    private func renderError(_ reason: String) {
        errorLabel.text = reason
        errorStackView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    private func renderLoading() {
        errorStackView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func renderSuccess() {
        errorStackView.isHidden = true
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource conformance
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier)
        if let cell = cell as? HeroCell {
            let hero = viewModel.heroes[indexPath.row]
            cell.setData(name: hero.name, photo: hero.photo)
        }
        return cell ?? UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    // Cuando se selecciona una celda navegamos al detalle aqui
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navega a algún lado, GUIÑO
        let selectedHero = viewModel.heroes[indexPath.row]
        let detailViewcontroller = HeroDetailBuilder().build(hero: selectedHero)
        navigationController?.pushViewController(detailViewcontroller, animated: true)
    }
}
