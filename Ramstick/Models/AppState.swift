

import SwiftUI
import Combine

class AppState: ObservableObject {
    // MARK: - Currency
    @Published var money: Int = 150 {
        didSet { UserDefaults.standard.set(money, forKey: "cf_money") }
    }

    // MARK: - Snake Stats
    @Published var snakeHighScore: Int = 0 {
        didSet { UserDefaults.standard.set(snakeHighScore, forKey: "cf_snake_hs") }
    }
    @Published var totalTrashCollected: Int = 0 {
        didSet { UserDefaults.standard.set(totalTrashCollected, forKey: "cf_trash") }
    }

    // MARK: - Quiz Stats
    @Published var quizHighScore: Int = 0 {
        didSet { UserDefaults.standard.set(quizHighScore, forKey: "cf_quiz_hs") }
    }
    @Published var totalQuizCorrect: Int = 0 {
        didSet { UserDefaults.standard.set(totalQuizCorrect, forKey: "cf_quiz_correct") }
    }

    // MARK: - Avatar Customization
    @Published var avatarBodyColor: Color = .cfMaroon
    @Published var avatarHeadAccessory: AvatarAccessory = .none
    @Published var avatarName: String = "HT Student"

    // MARK: - Unlocked Opportunities
    @Published var unlockedOpportunityIDs: Set<String> = []

    init() {
        money              = UserDefaults.standard.integer(forKey: "cf_money").nonZero ?? 150
        snakeHighScore     = UserDefaults.standard.integer(forKey: "cf_snake_hs")
        totalTrashCollected = UserDefaults.standard.integer(forKey: "cf_trash")
        quizHighScore      = UserDefaults.standard.integer(forKey: "cf_quiz_hs")
        totalQuizCorrect   = UserDefaults.standard.integer(forKey: "cf_quiz_correct")
    }

    func addMoney(_ amount: Int) {
        money = max(0, money + amount)
    }

    func unlockOpportunity(id: String, cost: Int) -> Bool {
        guard money >= cost, !unlockedOpportunityIDs.contains(id) else { return false }
        money -= cost
        unlockedOpportunityIDs.insert(id)
        return true
    }
}

extension Int {
    var nonZero: Int? { self == 0 ? nil : self }
}

// MARK: - Avatar Accessories
enum AvatarAccessory: String, CaseIterable, Identifiable {
    case none       = "None"
    case cap        = "Cap 🎓"
    case headband   = "Headband 🎽"
    case crown      = "Crown 👑"
    case halo       = "Halo ✨"

    var id: String { rawValue }
}

// MARK: - Color Theme
extension Color {
    static let cfMaroon    = Color(red: 0.55, green: 0.02, blue: 0.10)
    static let cfGreen     = Color(red: 0.18, green: 0.62, blue: 0.33)
    static let cfGold      = Color(red: 0.85, green: 0.65, blue: 0.13)
    static let cfBackground = Color(red: 0.97, green: 0.96, blue: 0.97)
    static let cfCard      = Color.white
    static let cfDark      = Color(red: 0.10, green: 0.08, blue: 0.12)
    static let cfGameBG    = Color(red: 0.06, green: 0.06, blue: 0.10)
}
