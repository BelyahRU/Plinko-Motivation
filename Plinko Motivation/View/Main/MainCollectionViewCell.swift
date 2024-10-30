
import Foundation
import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "MainCollectionViewCell"
    
    private let backView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "cellBack")
        return im
    }()
    
    private let ballsTaskView: UIImageView = {
        let im = UIImageView()
        im.image = UIImage(named: "taskView0")
        return im
    }()
    
    private let taskName: UILabel = {
       let label = UILabel()
        label.text = "To carry out general cleaning of the house"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    private let showDetails: UILabel = {
       let label = UILabel()
        label.text = "Show Details"
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }()
    
    private let tasksLabel: UILabel = {
        let label = UILabel()
         label.text = "Tasks"
         label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
         label.textColor = .white
         label.backgroundColor = .clear
         label.numberOfLines = 0
         return label
     }()
    
    private let totalPerscent: UILabel = {
        let label = UILabel()
         label.text = "0%"
         label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
         label.textColor = .white.withAlphaComponent(0.72)
         label.backgroundColor = .clear
         return label
     }()
    
    private let totalBalls: UILabel = {
        let label = UILabel()
         label.text = "0/10"
         label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
         label.textColor = .white
         label.backgroundColor = .clear
         return label
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
        addSubview(backView)
        addSubview(ballsTaskView)
        addSubview(taskName)
        addSubview(showDetails)
        addSubview(tasksLabel)
        addSubview(totalBalls)
        addSubview(totalPerscent)
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tasksLabel.snp.makeConstraints { make in
            make.centerX.equalTo(ballsTaskView.snp.centerX)
            make.top.equalToSuperview().offset(16)
        }
        
        ballsTaskView.snp.makeConstraints { make in
            make.width.equalTo(124)
            make.height.equalTo(110)
            make.top.equalToSuperview().offset(46)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        showDetails.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.snp.bottom).offset(-40)
        }
        taskName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(ballsTaskView.snp.leading).offset(-5)
        }
        
        totalBalls.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16-124/2)
            make.top.equalTo(ballsTaskView.snp.bottom)
        }
        
        totalPerscent.snp.makeConstraints { make in
            make.leading.equalTo(totalBalls.snp.trailing).offset(3)
            make.top.equalTo(ballsTaskView.snp.bottom)
        }
    }
    
    func setupCell(name: String, percent: String) {
        taskName.text = name
        ballsTaskView.image = UIImage(named: "taskView"+percent)
        totalPerscent.text = percent + "%"
        let total = Int(percent)! / 10
        totalBalls.text = "\(total)/10"
    }
}
