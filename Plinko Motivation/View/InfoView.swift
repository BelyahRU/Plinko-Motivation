import Foundation
import UIKit
final class InfoView: UIView {
    
    private let back = UIImageView(image:
            UIImage(named: Resources.Backgrounds.mainBackround))
    
    private let informationImage: UIImageView = {
       let im = UIImageView()
        im.image = UIImage(named: Resources.Images.informationImage)
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    public let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.backButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let textScrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = false
        return sv
    }()
    
    private let textImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Resources.Images.infoTextImage))
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        addSubview(backButton)
        addSubview(textScrollView)
        textScrollView.addSubview(informationImage)
        textScrollView.addSubview(textImageView)
    }

    
    private func setupConstraints() {
        back.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(188)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        textScrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(29)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10) // Ограничиваем скролл к низу экрана
            make.width.equalTo(348)
            make.centerX.equalToSuperview()
        }
        
        informationImage.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(348)
            make.centerX.equalToSuperview()
        }
        
        textImageView.snp.makeConstraints { make in
            make.top.equalTo(informationImage.snp.bottom).offset(24)
            make.bottom.equalToSuperview() // Указываем нижнее ограничение к нижней границе UIScrollView
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(textScrollView.snp.width)
        }
    }


}
