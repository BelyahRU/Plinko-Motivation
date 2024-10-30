import Foundation

// MARK: - Goal Model
struct Goal: Codable {
    var isDone: Bool
    var text: String
}

// MARK: - Block of Goals
class GoalBlock: Codable {
    var goals: [Goal]
    var name: String // Имя блока
    
    init(name: String = "Новый Блок") {
        // Каждый блок содержит 10 целей (по умолчанию пустых)
        self.goals = Array(repeating: Goal(isDone: false, text: ""), count: 10)
        self.name = name // Устанавливаем имя блока
    }
    
    // Добавляем или изменяем цель по индексу
    func updateGoal(at index: Int, isDone: Bool, text: String) {
        guard index >= 0 && index < goals.count else { return }
        goals[index] = Goal(isDone: isDone, text: text)
    }
    
    func getPercent() -> String{
        var percent = 0
        for i in goals {
            if i.isDone == true {
                percent += 10
            }
        }
        return "\(percent)"
    }
}

// MARK: - Goal Manager
class GoalManager {
    static let shared = GoalManager() // Создаем единственный экземпляр
    
    private var goalBlocks: [GoalBlock]
    private let userDefaultsKey = "goalBlocks"
    
    private init() { // Приватный инициализатор
        self.goalBlocks = []
        loadGoalBlocks()
        
        if goalBlocks.isEmpty {
            let defaultBlock = GoalBlock(name: "Finances") // Имя блока
            defaultBlock.updateGoal(at: 0, isDone: false, text: "Create a List of All Income Sources")
            defaultBlock.updateGoal(at: 1, isDone: false, text: "Create a List of All Expenses")
            defaultBlock.updateGoal(at: 2, isDone: false, text: "Analyze Monthly Cash Flow")
            defaultBlock.updateGoal(at: 3, isDone: false, text: "Set Financial Goals")
            defaultBlock.updateGoal(at: 4, isDone: false, text: "Build an Emergency Fund")
            defaultBlock.updateGoal(at: 5, isDone: false, text: "Assess Debt Obligations")
            defaultBlock.updateGoal(at: 6, isDone: false, text: "Review Current Savings and Investments")
            defaultBlock.updateGoal(at: 7, isDone: false, text: "Evaluate and Optimize Expenses")
            defaultBlock.updateGoal(at: 8, isDone: false, text: "Create a Budget for the Upcoming Period")
            defaultBlock.updateGoal(at: 9, isDone: false, text: "Review and Adjust the Plan Regularly")
            goalBlocks.append(defaultBlock)
            saveGoalBlocks()
        }
    }
    
    // MARK: - Block Management

    // Добавление нового блока целей с именем
    func addNewBlock(with name: String = "New block") {
        let newBlock = GoalBlock(name: name)
        goalBlocks.append(newBlock)
        saveGoalBlocks() // Сохраняем после добавления блока
    }
    
    // Удаление блока по индексу
    func deleteBlock(at index: Int) {
        guard index >= 0 && index < goalBlocks.count else { return }
        goalBlocks.remove(at: index)
        saveGoalBlocks() // Сохраняем после удаления блока
    }
    
    // Получение блока по индексу
    func getBlock(at index: Int) -> GoalBlock? {
        guard index >= 0 && index < goalBlocks.count else { return nil }
        return goalBlocks[index]
    }

    // MARK: - Goal Management in a Block

    // Редактирование цели в указанном блоке
    func updateGoal(inBlock blockIndex: Int, goalIndex: Int, isDone: Bool, text: String) {
        guard let block = getBlock(at: blockIndex) else { return }
        block.updateGoal(at: goalIndex, isDone: isDone, text: text)
        saveGoalBlocks() // Сохраняем после обновления цели
    }
    
    // Получение всех блоков целей
    func getAllBlocks() -> [GoalBlock] {
        return goalBlocks
    }
    
    // MARK: - UserDefaults Management

    private func saveGoalBlocks() {
        if let data = try? JSONEncoder().encode(goalBlocks) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadGoalBlocks() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let blocks = try? JSONDecoder().decode([GoalBlock].self, from: data) {
            goalBlocks = blocks
        }
    }
}
