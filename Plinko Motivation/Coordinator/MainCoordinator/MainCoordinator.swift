
import Foundation
import UIKit

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController!
//    var mainViewController: MainViewController!
    var mainViewController: GameScreenViewController!
    var infoViewController: InfoViewController!
    
    func start() {
        showMain()
    }
    
    func showMain() {
//        mainViewController = MainViewController()
        mainViewController = GameScreenViewController()
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
}

