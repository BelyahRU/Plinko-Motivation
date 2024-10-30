import UIKit
import SpriteKit
import SnapKit

class GameScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dropPositionX: CGFloat = UIScreen.main.bounds.width / 2
    private var showingBetSheet: Bool = false
    private var selectedBet: Double = 10
    private var isBallDropped: Bool = false
    private var hasBallLanded: Bool = false
    private var isBonusActive: Bool = false
    private var gameScene: SKScene!
    var skView: SKView!
    
    var targetScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceHorizontal = false
        return sv
    }()
    
    let backgroundImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "longBack"))
        return im
    }()
    
    let financialAnalysisImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "financialAnalysis"))
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    public let backButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.backButton), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(targetScrollView)
        targetScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupBackgroundImage()
        setupGameContentView()
        setupDropOrRestartButton()
        setupBackButton()
        setupFinancialAnalysisImageView()
    }
    
    private func setupBackgroundImage() {
        targetScrollView.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1250)  // Высота длинного фона
        }
        
        // Устанавливаем contentSize для targetScrollView, чтобы охватить весь фон
        targetScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1250)
    }
    
    private func setupGameContentView() {
        gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = .clear
        skView = SKView()
        skView = SKView(frame: CGRect(x: 20, y: 170, width: 342, height: 519))
        skView.presentScene(gameScene)
        skView.backgroundColor = .clear
        targetScrollView.addSubview(skView)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        skView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupDropOrRestartButton() {
        let button = UIButton()
        button.setImage(UIImage(named: Resources.Buttons.launchTheBall), for: .normal)
        targetScrollView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(skView.snp.bottom).offset(-16)
            make.width.equalTo(310)
            make.height.equalTo(60)
        }
        button.addTarget(self, action: #selector(dropOrRestartBall), for: .touchUpInside)
    }
    
    private func setupFinancialAnalysisImageView() {
        targetScrollView.addSubview(financialAnalysisImageView)
        financialAnalysisImageView.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.centerX.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(24)
        }
    }
    
    private func setupBackButton() {
        targetScrollView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(188)
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(self.backgroundImageView.safeAreaLayoutGuide.snp.top).offset(5)
        }
    }
    
    // MARK: - Actions and Observers
    
    @objc private func dropOrRestartBall() {
        dropBall()
    }
    
    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        if !isBallDropped {
            let location = gesture.location(in: view)
            NotificationCenter.default.post(name: NSNotification.Name("moveBallToPosition"), object: location.x)
        }
    }
    
    private func dropBall() {
        isBallDropped = true
        NotificationCenter.default.post(name: NSNotification.Name("dropBallAtPosition"), object: dropPositionX)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ballLanded), name: NSNotification.Name("ballLanded"), object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func ballLanded() {
        hasBallLanded = true
        isBallDropped = false
    }
}
