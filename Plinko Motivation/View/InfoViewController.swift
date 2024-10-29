
import UIKit

final class InfoViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let infoView = InfoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupButtons()
    }

    private func configure() {
        setupUI()
        setupButtons()
    }
    
    private func setupUI() {
        view.addSubview(infoView)
        
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension InfoViewController {
    
    public func setupButtons() {
        infoView.backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
    }

    @objc
    func backPressed() {
        print("LOGGER: back pressed")
        coordinator?.backPressed()
    }
   
}
