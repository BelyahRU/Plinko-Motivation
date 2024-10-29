
import Foundation
import UIKit
import SnapKit

final class MainView: UIView {
    
    private let back = UIImageView(image:
            UIImage(named: Resources.Backgrounds.mainBackround))
    
    private let logoImage: UIImageView = {
       let im = UIImageView()
        im.image = UIImage(named: Resources.Images.plinkoLogoImage)
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    private let buttonsStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.backgroundColor = .clear
        sv.spacing = 4
        return sv
    }()
    
    public let achievmentsButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.achievmentsButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    public let addTargetButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.addTargetButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    public let infoButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.infoButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    public let settingsButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.settingsButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
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
        addSubview(logoImage)
        addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(addTargetButton)
        buttonsStackView.addArrangedSubview(achievmentsButton)
        buttonsStackView.addArrangedSubview(infoButton)
        buttonsStackView.addArrangedSubview(settingsButton)
    }
    
    private func setupConstraints() {
        back.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(100)
            make.width.equalTo(248)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(logoImage.snp.bottom).offset(32)
            make.height.equalTo(56)
        }
        
        addTargetButton.snp.makeConstraints { make in
            make.width.equalTo(174)
            make.height.equalTo(52)
        }
        
        [achievmentsButton, infoButton, settingsButton].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(52)
            }
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
