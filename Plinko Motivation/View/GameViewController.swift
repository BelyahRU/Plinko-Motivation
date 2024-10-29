
import UIKit
import SpriteKit

class GameScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    private var score = 500
    private var multiplier: Double = 1.0
    private var currentMultiplier: Double = 1.0
    private var dropPositionX: CGFloat = UIScreen.main.bounds.width / 2
    
    private var showingBetSheet: Bool = false
    private var selectedBet: Double = 10
    
    private var isBallDropped: Bool = false
    private var hasBallLanded: Bool = false
    private var isBonusActive: Bool = false
    private var isMultiplierUsed: Bool = false
    
    private var gameScene: SKScene!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadScore()
        setupObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        setupBackgroundView()
        setupGameContentView()
        setupScoreView()
        setupActionButtons()
        setupDropOrRestartButton()
    }
    
    private func setupBackgroundView() {
        let backgroundImageView = UIImageView(image: UIImage(named: "AppBackground"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
    }
    
    private func setupGameContentView() {
        gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        let skView = SKView(frame: CGRect(x: 20, y: 150, width: 342, height: 519))
        skView.presentScene(gameScene)
        view.addSubview(skView)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        skView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupScoreView() {
        let scoreLabel = UILabel()
        scoreLabel.text = "\(score)"
        scoreLabel.font = UIFont(name: "Fredoka-Bold", size: 38)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.frame = CGRect(x: (view.bounds.width - 200) / 2, y: 60, width: 200, height: 90)
        scoreLabel.backgroundColor = UIColor(red: 1, green: 191/255, blue: 0, alpha: 1)
        scoreLabel.layer.cornerRadius = 45
        scoreLabel.layer.masksToBounds = true
        view.addSubview(scoreLabel)
    }
    
    
    private func setupDropOrRestartButton() {
        let button = UIButton()
        button.setTitle("Drop Ball", for: .normal)
        button.titleLabel?.font = UIFont(name: "Fredoka-Bold", size: 38)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: (view.bounds.width - 200) / 2, y: view.bounds.height - 150, width: 200, height: 90)
        button.backgroundColor = UIColor(red: 1, green: 191/255, blue: 0, alpha: 1)
        button.layer.cornerRadius = 45
        button.addTarget(self, action: #selector(dropOrRestartBall), for: .touchUpInside)
        view.addSubview(button)
    }
    
    // MARK: - Actions and Observers
    
    @objc private func dropOrRestartBall() {
        dropBall()
    }
    
    @objc private func handleDrag(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        dropPositionX = min(max(location.x, 0), UIScreen.main.bounds.width)
        NotificationCenter.default.post(name: NSNotification.Name("moveBallToPosition"), object: dropPositionX)
    }
    
    private func dropBall() {
        isBallDropped = true
        NotificationCenter.default.post(name: NSNotification.Name("dropBallAtPosition"), object: dropPositionX)
    }
    var counter = -10000
    @objc private func restartGameButton() {
        dropPositionX = UIScreen.main.bounds.width / 2
        counter += 1
        print(counter)
        NotificationCenter.default.post(name: NSNotification.Name("restartGame"), object: nil)
        isBallDropped = false
    }
    
    private func loadScore() {
        score = UserDefaults.standard.integer(forKey: "userScore")
    }
    
    private func saveScore() {
        UserDefaults.standard.set(score, forKey: "userScore")
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMultiplier(_:)), name: NSNotification.Name("updateMultiplier"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ballLanded), name: NSNotification.Name("ballLanded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartGameButton), name: NSNotification.Name("restartGame"), object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func updateMultiplier(_ notification: Notification) {
        if let multiplier = notification.object as? Double {
            currentMultiplier = multiplier
        }
        saveScore()
    }
    
    @objc private func ballLanded() {
        hasBallLanded = true
        score = Int(Double(score) * currentMultiplier)
        saveScore()
    }
}


