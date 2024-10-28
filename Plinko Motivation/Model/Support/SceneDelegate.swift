
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator!
    var navigationController: UINavigationController!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        loadView()
    }

    

    func loadView() {
        navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        coordinator = MainCoordinator()
        coordinator.navigationController = navigationController
        coordinator.start()
        
        window?.rootViewController = navigationController
        let nav = UINavigationController()
        nav.navigationBar.isHidden = true
        window?.makeKeyAndVisible()
        
    }
}

