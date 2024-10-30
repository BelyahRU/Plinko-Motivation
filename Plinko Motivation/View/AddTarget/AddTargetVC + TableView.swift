
import Foundation
import UIKit

extension AddTargetViewController: UITableViewDataSource, UITableViewDelegate {
    func setupTableView() {
        targetsBackImageView.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TargetCell.self, forCellReuseIdentifier: TargetCell.reuseId)
        
        let tableViewHeight = CGFloat(10 * 48)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(targetsBackImageView).offset(126)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(tableViewHeight)
            make.bottom.equalToSuperview()
        }
        targetsScrollView.snp.makeConstraints { make in
            make.bottom.equalTo(saveTargetButton.snp.bottom).offset(100)
        }
        targetsScrollView.bringSubviewToFront(tableView)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TargetCell.reuseId, for: indexPath) as? TargetCell else {
            return UITableViewCell()
        }
        cell.numberLabel.text = "\(indexPath.row + 1) "
        cell.backgroundColor = .clear
        cell.textField.text = targetTexts[indexPath.row]
        cell.textField.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, let row = textField.tag as Int? {
            targetTexts[row] = text // Сохраняем текст в массиве
        }
    }

}
