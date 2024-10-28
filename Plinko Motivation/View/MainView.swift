
import Foundation
import UIKit
import SnapKit

final class MainView: UIView {
    
    private let back = UIImageView(image:
            UIImage(named: Resources.Backgrounds.mainBackround))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        addSubview(back)
    }
    
    private func setupConstraints() {
        back.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



//import Foundation
//import UIKit
//
//final class MainView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func configure() {
//
//    }
//
//    private func setupSubviews() {
//
//    }
//
//    private func setupConstraints() {
//
//    }
//}
