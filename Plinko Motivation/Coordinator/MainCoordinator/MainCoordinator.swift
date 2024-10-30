
import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController!
    var mainViewController: MainViewController!
    var infoViewController: InfoViewController!
    var addTargetViewController: AddTargetViewController!
    
    func start() {
        showMain()
    }
    
    func showMain() {
        mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showInfo() {
        infoViewController = InfoViewController()
        infoViewController.coordinator = self
        navigationController.pushViewController(infoViewController, animated: true)
    }
    
    func backPressed() {
        navigationController.popViewController(animated: true)
    }
    
    func showAddTarget() {
        addTargetViewController = AddTargetViewController()
        addTargetViewController.coordinator = self
        navigationController.pushViewController(addTargetViewController, animated: true)
    }
}

