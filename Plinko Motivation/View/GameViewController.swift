
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
    
    private func setupActionButtons() {
        // Implement buttons and action handlers as needed for `bonusButton` and `multiplierButton`
    }
    
    private func setupDropOrRestartButton() {
        let button = UIButton()
        button.setTitle(isBallDropped ? "Restart" : "Drop Ball", for: .normal)
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
        if isBallDropped {
            restartGame()
        } else {
            dropBall()
        }
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
    
    @objc private func restartGame() {
        dropPositionX = UIScreen.main.bounds.width / 2
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
        NotificationCenter.default.addObserver(self, selector: #selector(restartGame), name: NSNotification.Name("restartGame"), object: nil)
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


import SwiftUI
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    private var ball: SKShapeNode?
    private let ballRadius: CGFloat = 10
    private let pegRadius: CGFloat = 4
    private let boxWidth: CGFloat = 29
    private let boxHeight: CGFloat = 20
    private let boxCount: Int = 10
    private let numberOfRows: Int = 10
    private let spacing: CGFloat = 40
   
    private let centralX: CGFloat
    private let horizontalLimit: CGFloat = 30.0
   
    private var boxMultipliers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
   
    private var isLaunching: Bool = true
    private var hasBallLanded = false
    private var isBonusActive: Bool = false

    // MARK: - Initializers
    
    override init() {
        self.centralX = UIScreen.main.bounds.width / 2
        super.init(size: CGSize(width: 342, height: 519))
        let backTextrure = SKTexture(image: UIImage(named: "backback")!)
        let backnode = SKSpriteNode(texture: backTextrure)
        backnode.position = CGPoint(x: 171, y: 259.5)
        backnode.size = CGSize(width: 342, height: 519)
        backnode.zPosition = -1 // Размещаем поверх фона
    
        addChild(backnode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Scene Setup
    
    public override func didMove(to view: SKView) {
        setupPhysicsWorld()
        setupNotifications()
        createInitialScene()
    }
    
    private func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -15)
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(dropBallAtPosition(_:)), name: NSNotification.Name("dropBallAtPosition"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartGame(_:)), name: NSNotification.Name("restartGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveBallToPosition(_:)), name: NSNotification.Name("moveBallToPosition"), object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(isBounusActiveNotification), name: NSNotification.Name("bonusButtonPressed"), object: nil)
       
    }
    
    // MARK: - Notifications
    
    @objc private func isBounusActiveNotification() {
        isBonusActive = true
    }
    
    // MARK: - Game Logic
    
    private func createInitialScene() {
        createBall(at: CGPoint(x: size.width / 2, y: size.height - 30))
        createInvertedTrianglePegs()
//        createPyramidPegs()
        createBoxesWithRandomZeroMultiplier()
    }
    
    

    private func createBoxesWithRandomZeroMultiplier() {
        let startY: CGFloat = 128
        let totalBoxWidth = CGFloat(boxCount) * boxWidth
        let totalSpacing = CGFloat(boxCount - 1) * spacing / 10
        let startX = (size.width - (totalBoxWidth + totalSpacing)) / 2
        
        var dynamicBoxMultipliers = boxMultipliers
        let shouldHaveZero = Bool.random()
        
        if shouldHaveZero {
            let randomIndex = Int.random(in: 0..<boxCount)
            dynamicBoxMultipliers[randomIndex] = 0
        }

        for i in 0..<boxCount {
            let boxX = startX + CGFloat(i) * (boxWidth + spacing / 10)
            createBox(at: CGPoint(x: boxX, y: startY), withMultiplier: dynamicBoxMultipliers[i])
        }
    }
    
    private func createBox(at position: CGPoint, withMultiplier multiplier: Int) {
        createBoxWalls(at: position, withMultiplier: multiplier) // Передаем множитель
        addMultiplierLabelWithBackground(at: position, withMultiplier: multiplier, imageName: "skullIcon")
    }

    private func addMultiplierLabelWithBackground(at position: CGPoint, withMultiplier multiplier: Int, imageName: String?) {

        let path = UIBezierPath()

        path.move(to: CGPoint(x: -boxWidth / 2, y: -boxHeight / 2))
        path.addLine(to: CGPoint(x: -boxWidth / 2, y: boxHeight / 2))
        path.addLine(to: CGPoint(x: boxWidth / 2, y: boxHeight / 2))
        path.addLine(to: CGPoint(x: boxWidth / 2, y: -boxHeight / 2))
        path.close()
        
        let texture = SKTexture(imageNamed: "box")
        let imageNode = SKSpriteNode(texture: texture)
        imageNode.size = CGSize(width: boxWidth, height: boxHeight)
        imageNode.position = CGPoint(x: position.x + boxWidth / 2, y: position.y + boxHeight / 2)
        imageNode.zPosition = 1 // Размещаем поверх фона
        imageNode.name = "box"
    
        addChild(imageNode)
        let label = SKLabelNode(text: "\(multiplier)")
        label.fontColor = .green
        label.fontSize = 14
        label.position = CGPoint(x: position.x + boxWidth / 2, y: position.y + boxHeight / 2)
        label.zPosition = 2
        addChild(label)
        
    }

    private func createBoxWalls(at position: CGPoint, withMultiplier multiplier: Int) {
        let walls = [
            SKSpriteNode(color: .clear, size: CGSize(width: 2, height: boxHeight)), // Левая граница
            SKSpriteNode(color: .clear, size: CGSize(width: 2, height: boxHeight)), // Правая граница
            SKSpriteNode(color: .clear, size: CGSize(width: boxWidth, height: 2)) // Нижняя граница
        ]
        
        walls[0].position = CGPoint(x: position.x, y: position.y + boxHeight / 2)
        walls[1].position = CGPoint(x: position.x + boxWidth, y: position.y + boxHeight / 2)
        walls[2].position = CGPoint(x: position.x + boxWidth / 2, y: position.y);
        
        for wall in walls {
            wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
            wall.physicsBody?.isDynamic = false
            wall.name = "box"
            addChild(wall)
        }
    }


   public override func update(_ currentTime: TimeInterval) {
        if !hasBallLanded, let ball = ball {
            let boxIndex = checkBallInBoxes(ballPosition: ball.position)
            if boxIndex != -1 {
                let multiplier = boxMultipliers[boxIndex]
                NotificationCenter.default.post(name: NSNotification.Name("updateMultiplier"), object: multiplier)
                print("Шарик попал в ячейку с индексом: \(boxIndex) и коэффициентом: \(multiplier)x")
                
                hasBallLanded = true
                NotificationCenter.default.post(name: NSNotification.Name("ballLanded"), object: nil)
            }
        }
        applyForceTowardsCenter()
    }

    private func checkBallInBoxes(ballPosition: CGPoint) -> Int {
        let startY: CGFloat = 10

        let totalBoxWidth = CGFloat(boxCount) * boxWidth
        let totalSpacing = CGFloat(boxCount - 1) * spacing / 10
        let startX = (size.width - (totalBoxWidth + totalSpacing)) / 2
        
        for i in 0..<boxCount {
            let boxX = startX + CGFloat(i) * (boxWidth + spacing / 10)
            let boxRect = CGRect(x: boxX, y: startY, width: boxWidth, height: boxHeight)

            if boxRect.contains(ballPosition) {
                return i // Возвращаем индекс ячейки
            }
        }
        return -1 // Возвращаем -1, если шарик не попал в ни одну ячейку
    }

    private func smallestMultiplier() -> Int? {
        return boxMultipliers.min()
    }
    
    

    
    private func createInvertedTrianglePegs() {
        let topY = size.height * 0.8
        let startingPegs = 3
        let endingPegs = 10
        
        for i in 0..<7 {
            let pegsInRow = startingPegs + i * (endingPegs - startingPegs) / (numberOfRows - 1)
            let totalWidth = CGFloat(pegsInRow - 1) * spacing
            let xOffset = (size.width - totalWidth) / 2
            
            for j in 0..<pegsInRow {
                let pegX = xOffset + CGFloat(j) * spacing
                let pegY = topY - CGFloat(i) * spacing
                createPeg(at: CGPoint(x: pegX, y: pegY))
            }
        }
    }
    
    private func createPeg(at position: CGPoint) {
        let peg = SKShapeNode(circleOfRadius: pegRadius)
        peg.position = position
        peg.fillColor = .white
        
        peg.physicsBody = SKPhysicsBody(circleOfRadius: pegRadius)
        peg.physicsBody?.isDynamic = false
        peg.physicsBody?.friction = 0.3
        peg.physicsBody?.restitution = 0.4
        peg.physicsBody?.categoryBitMask = 1
        peg.physicsBody?.contactTestBitMask = 2
        
        addChild(peg)
    }
    
    private func createBall(at position: CGPoint) {
        
        ball = SKShapeNode(circleOfRadius: ballRadius)
        ball?.position = position
        ball?.fillColor = .orange
        
        let ballPhysicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        ballPhysicsBody.friction = 0.2
        ballPhysicsBody.restitution = 0.6
        ballPhysicsBody.linearDamping = 0.1
        ballPhysicsBody.angularDamping = 0.1
        ballPhysicsBody.isDynamic = false
        ballPhysicsBody.categoryBitMask = 2
        ballPhysicsBody.contactTestBitMask = 1
        
        ball?.physicsBody = ballPhysicsBody
        
        ball?.name = "ball"

        if let ball = ball {
            addChild(ball)
        }
    }
    
    // MARK: - Ball Dropping
    
    @objc private func dropBallAtPosition(_ notification: Notification) {
        guard let dropPositionX = notification.object as? CGFloat else { return }
        let constrainedXPosition = constrainDropPosition(dropPositionX)

        if isBonusActive {
            ball?.removeFromParent()
            
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {

                    let ballPosition = CGPoint(x: constrainedXPosition + CGFloat(i) * 5.0, y: self.size.height - 30)
                    self.createBall(at: ballPosition)
                    
                    if let newBall = self.ball {
                        newBall.physicsBody?.isDynamic = true
                    }
                }
            }
        } else {
            ball?.position = CGPoint(x: constrainedXPosition, y: size.height - 30)
            ball?.physicsBody?.isDynamic = true
        }

        isLaunching = false
        applyForceTowardsCenter()
    }
    
    private func constrainDropPosition(_ dropPositionX: CGFloat) -> CGFloat {
        let minXPosition = centralX - horizontalLimit
        let maxXPosition = centralX + horizontalLimit
        return min(max(dropPositionX, minXPosition), maxXPosition)
    }
    
    @objc private func moveBallToPosition(_ notification: Notification) {
        guard let newXPosition = notification.object as? CGFloat else { return }
        ball?.position.x = newXPosition
    }
    
    // MARK: - Game Reset
    
    @objc private func restartGame(_ notification: Notification) {
        // Удаляем старый шарик
        removeAllBalls()
        
        // Создаем новый шарик
        createBall(at: CGPoint(x: size.width / 2, y: size.height - 30))
        
        // Сбрасываем состояние
        hasBallLanded = false
        isLaunching = true
        
    }
    
    private func removeAllBalls() {
        // Удаляем все шары (если они существуют)
        children.filter { $0.name == "ball" }.forEach { $0.removeFromParent() }
    }
    
    // MARK: - Collision Handling
    
    public func didBegin(_ contact: SKPhysicsContact) {
        handleBallCollision(with: contact)
    }
    
    private func handleBallCollision(with contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if isBallCollidingWithPeg(bodyA, bodyB) {
            animatePegCollision(for: bodyA, bodyB)
        }
    }
    
    private func isBallCollidingWithPeg(_ bodyA: SKPhysicsBody, _ bodyB: SKPhysicsBody) -> Bool {
        return (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2) || (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1)
    }
    
    private func animatePegCollision(for bodyA: SKPhysicsBody, _ bodyB: SKPhysicsBody) {
        let pegNode = bodyA.categoryBitMask == 1 ? bodyA.node : bodyB.node
        animatePeg(pegNode)
    }
    
    private func animatePeg(_ pegNode: SKNode?) {
        guard let peg = pegNode else { return }
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        peg.run(sequence)
    }
    
    private func applyForceTowardsCenter() {
        guard let ball = ball, let physicsBody = ball.physicsBody else { return }
        
        let ballPositionX = ball.position.x
        let distanceToCenter = centralX - ballPositionX
        
        if isLaunching {
            constrainBallPosition()
        }
        
        let forceMagnitude: CGFloat = distanceToCenter * CGFloat.random(in: 0.02...0.1)
        physicsBody.applyForce(CGVector(dx: forceMagnitude, dy: 0))
    }
    
    private func constrainBallPosition() {
        guard let ball = ball else { return }
        let minXPosition = centralX - horizontalLimit
        let maxXPosition = centralX + horizontalLimit
        
        if ball.position.x < minXPosition {
            ball.position.x = minXPosition
        } else if ball.position.x > maxXPosition {
            ball.position.x = maxXPosition
        }
    }
}
