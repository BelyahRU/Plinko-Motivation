
import UIKit

final class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let viewModel = MainViewModel()
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        setupUI()
        setupButtons()
        setupCollectionView()
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


