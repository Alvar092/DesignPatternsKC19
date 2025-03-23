import UIKit

// Suscribirse a los eventos del VM
// Mostrar los datos del hero y gestionar la UI 

final class HeroDetailViewController: UIViewController {
    private let viewModel: HeroDetailViewModel
    private let heroName: String
    
    @IBOutlet var heroImageView: AsyncImage!
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var descriptionScrollView: UIScrollView!
    @IBOutlet var heroDescriptionLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    init(viewModel: HeroDetailViewModel, heroName: String) {
        self.viewModel = viewModel
        self.heroName = heroName
        super.init(nibName: "HeroDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isViewLoaded{
            bind()
            viewModel.loadHero()
        }
    }
    
    private func setupUI() {
        heroNameLabel.text = heroName
        heroDescriptionLabel.text = viewModel.hero?.description
        if let photoURL = viewModel.hero?.photo {
            heroImageView.setImage(photoURL)
        }
        descriptionScrollView.alwaysBounceHorizontal = false
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            DispatchQueue.main.async{
                switch state {
                case .loading:
                    self?.activityIndicator.startAnimating()
                case .success:
                    self?.setupUI()
                    self?.activityIndicator.stopAnimating()
                    
                case .error(let reason):
                    self?.activityIndicator.stopAnimating()
                    
                }
            }
        }
    }
}
