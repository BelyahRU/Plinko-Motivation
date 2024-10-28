
import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController!
    var mainViewController: MainViewController!
    
    func start() {
        mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    
}

