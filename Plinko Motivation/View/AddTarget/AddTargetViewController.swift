import UIKit
import SnapKit

final class AddTargetViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    var targetTexts: [String] = Array(repeating: "", count: 10) // Массив для хранения текстов

    let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()
    
    let backgroundImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "longBack")
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    let targetsBackImageView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "addTargetBack")
        im.contentMode = .scaleAspectFill
        return im
    }()
    
    let addTargetView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "addTargetView")
        im.contentMode = .scaleAspectFill
        return im
    }()

    var targetsScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = false
        return sv
    }()
    
    let saveTargetButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "saveTargetButton"), for: .normal)
        return button
    }()
    
    public let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setupUI()
        setupTableView()
        setupButtons()
    }

    private func setupUI() {
        view.addSubview(targetsScrollView)
        targetsScrollView.addSubview(backgroundImageView)
        targetsScrollView.addSubview(targetsBackImageView)
        targetsScrollView.addSubview(saveTargetButton)
        targetsScrollView.addSubview(backButton)
        targetsScrollView.addSubview(addTargetView)
        
        targetsScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1250)
        }
        
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(188)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(backgroundImageView.safeAreaLayoutGuide.snp.top).offset(5)
        }
        
        addTargetView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(24)
        }
        
        targetsBackImageView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.centerX.equalToSuperview()
            make.height.equalTo(654)
            make.top.equalTo(addTargetView.snp.bottom).offset(12)
        }
        
        saveTargetButton.snp.makeConstraints { make in
            make.width.equalTo(310)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(targetsBackImageView.snp.bottom).offset(-16)
        }
        
    }

}

class CustomScrollView: UIScrollView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        // Если пользователь нажимает на UITextField, возвращаем его
        if let textField = view as? UITextField {
            return textField
        }
        return view // Возвращаем любой другой вид, с которым можно взаимодействовать
    }
}
