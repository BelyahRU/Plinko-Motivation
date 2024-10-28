
import UIKit

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

