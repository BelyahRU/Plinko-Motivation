
import Foundation
import UIKit

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setupCollectionView() {
        mainView.targetsCollectionView.delegate = self
        mainView.targetsCollectionView.dataSource = self
        
        mainView.targetsCollectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.reuseId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getTotalCountBlocks()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseId, for: indexPath)
                as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let block = viewModel.getBlock(by: indexPath.row) else {
            return cell
        }
        cell.setupCell(name: block.name, percent: block.getPercent())
        return cell
    }
}
