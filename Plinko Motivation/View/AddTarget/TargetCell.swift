
import Foundation
import UIKit
import SnapKit

class TargetCell: UITableViewCell {
    
    static let reuseId = "TargetCell"
    
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "   Enter your goal"
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.backgroundColor = .black.withAlphaComponent(0.52)
        tf.layer.cornerRadius = 16
        tf.clipsToBounds = true
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
        self.selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCellLayout() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(textField)
        numberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(numberLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.width.equalTo(286)
            make.height.equalTo(40)
        }
    }
}
