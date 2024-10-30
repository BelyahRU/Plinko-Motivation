
import Foundation
import UIKit

extension AddTargetViewController {
    func setupButtons() {
        backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
    }
    
    @objc
    func backPressed() {
        coordinator?.backPressed()
    }
}
