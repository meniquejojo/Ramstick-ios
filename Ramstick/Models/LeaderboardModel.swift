

import SwiftUI
import Foundation
import Combine

// MARK: - Leaderboard Entry
struct LeaderboardEntry: Identifiable, Codable {
    let id: String
    var name: String
    var avatarEmoji: String
    var snakeScore: Int
    var quizScore: Int
    var challengeStreak: Int
    var totalCoins: Int
    var weekLabel: String       // "2025-W12"

    var totalScore: Int {
        snakeScore + (quizScore * 10) + (challengeStreak * 15) + (totalCoins / 5)
    }
}

// MARK: - Leaderboard Manager
class LeaderboardManager: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var currentWeekLabel: String = ""
    @Published var playerRank: Int = 0
    @Published var lastResetDate: String = ""
    @Published var prizePool: Int = 0

    private let storageKey = "cf_leaderboard_v1"
    private let weekKey    = "cf_lb_week"
    private let entryFee   = 20          // coins to enter tournament

    init() {
        currentWeekLabel = weekLabel(for: Date())
        loadEntries()
        checkWeeklyReset()
        if entries.isEmpty { seedMockPlayers() }
    }

    // MARK: - Enter Tournament
    func enterTournament(appState: AppState, playerName: String) -> Bool {
        guard appState.money >= entryFee else { return false }
        appState.addMoney(-entryFee)
        prizePool += entryFee
        return true
    }

    // MARK: - Submit Score
    func submitScore(appState: AppState, playerName: String) {
        let weekStr = weekLabel(for: Date())
        let playerID = "player_me"

        let entry = LeaderboardEntry(
            id: playerID,
            name: playerName,
            avatarEmoji: "🎓",
            snakeScore: appState.snakeHighScore,
            quizScore: appState.quizHighScore,
            challengeStreak: 0,           // passed in from dcState if needed
            totalCoins: appState.money,
            weekLabel: weekStr
        )

        if let idx = entries.firstIndex(where: { $0.id == playerID }) {
            entries[idx] = entry
        } else {
            entries.append(entry)
        }

        entries.sort { $0.totalScore > $1.totalScore }
        playerRank = (entries.firstIndex(where: { $0.id == playerID }) ?? 0) + 1
        saveEntries()
    }

    // MARK: - Weekly Reset
    private func checkWeeklyReset() {
        let stored = UserDefaults.standard.string(forKey: weekKey) ?? ""
        if stored != currentWeekLabel {
            // New week — archive and reset
            UserDefaults.standard.set(currentWeekLabel, forKey: weekKey)
            entries = []
            prizePool = 0
            seedMockPlayers()
            saveEntries()
        }
    }

    private func weekLabel(for date: Date) -> String {
        let cal  = Calendar.current
        let week = cal.component(.weekOfYear, from: date)
        let year = cal.component(.year, from: date)
        return "\(year)-W\(week)"
    }

    // MARK: - Persistence
    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([LeaderboardEntry].self, from: data) else { return }
        entries = decoded
        entries.sort { $0.totalScore > $1.totalScore }
    }

    // MARK: - Mock competitors (seeded fresh each week)
    private func seedMockPlayers() {
        let mockNames = [
            ("Jaylen M.", "🏀"), ("Amara T.", "✨"), ("DeShawn R.", "🎵"),
            ("Priya K.", "📚"), ("Marcus B.", "💻"), ("Zara W.", "🎨"),
            ("Chris O.", "⚡️"), ("Tiana L.", "🌟"), ("Isaiah F.", "🔥"),
        ]
        entries = mockNames.enumerated().map { i, pair in
            LeaderboardEntry(
                id: "mock_\(i)",
                name: pair.0,
                avatarEmoji: pair.1,
                snakeScore:       Int.random(in: 20...180),
                quizScore:        Int.random(in: 3...8),
                challengeStreak:  Int.random(in: 1...12),
                totalCoins:       Int.random(in: 80...400),
                weekLabel: currentWeekLabel
            )
        }
        entries.sort { $0.totalScore > $1.totalScore }
    }

    var timeUntilReset: String {
        let cal = Calendar.current
        var comps = DateComponents()
        comps.weekday = 1      // Sunday
        comps.hour    = 0
        comps.minute  = 0
        comps.second  = 0
        guard let nextSunday = cal.nextDate(after: Date(), matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents) else { return "--:--:--" }
        let diff = Int(nextSunday.timeIntervalSinceNow)
        let h = diff / 3600
        let m = (diff % 3600) / 60
        let s = diff % 60
        return String(format: "%02dh %02dm %02ds", h, m, s)
    }

    var topThreePrizes: [Int] {
        let total = max(prizePool + 100, 150)   // guarantee a minimum pool
        return [Int(Double(total) * 0.5), Int(Double(total) * 0.3), Int(Double(total) * 0.2)]
    }
}


