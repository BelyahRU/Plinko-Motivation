
import UIKit

final class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        setupUI()
        setupButtons()
    }
    
    private func setupUI() {
        view.addSubview(mainView)
        
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainViewController {
    
    public func setupButtons() {
        mainView.achievmentsButton.addTarget(self, action: #selector(achievmentsPressed), for: .touchUpInside)
        mainView.addTargetButton.addTarget(self, action: #selector(addNewTargetPressed), for: .touchUpInside)
        mainView.infoButton.addTarget(self, action: #selector(infoPressed), for: .touchUpInside)
        mainView.settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
    }
    
    @objc
    func addNewTargetPressed() {
        print("LOGGER: addNewTarget pressed")
    }
    
    @objc
    func settingsPressed() {
        print("LOGGER: settings pressed")
    }
    
    @objc
    func infoPressed() {
        print("LOGGER: info pressed")
        coordinator?.showInfo()
    }
    
    @objc
    func achievmentsPressed() {
        print("LOGGER: achievments pressed")
    }
}
