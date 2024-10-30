
import Foundation
import UIKit

class MainViewModel {
    let goalManager = GoalManager.shared
    
    func getTotalCountBlocks() -> Int {
        return goalManager.getAllBlocks().count
    }
    
    func getBlock(by id: Int) -> GoalBlock? {
        return goalManager.getBlock(at: id)
    }
}
