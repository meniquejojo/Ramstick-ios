// LeaderboardView.swift

import SwiftUI
import Combine

struct LeaderboardView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var lb = LeaderboardManager()
    @State private var isEntered = false
    @State private var showEntryAlert = false
    @State private var showSubmitAlert = false
    @State private var showNotEnoughCoins = false
    @State private var countdownText = ""
    @State private var selectedTab = 0      // 0 = This Week, 1 = How It Works

    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── Reset countdown banner
                    ResetCountdownBanner(timeLeft: countdownText, prizePool: lb.prizePool + 100)
                        .padding(.horizontal, 16)

                    // ── Tab picker
                    Picker("", selection: $selectedTab) {
                        Text("This Week").tag(0)
                        Text("How It Works").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .colorMultiply(Color(red: 0.2, green: 0.2, blue: 0.2))

                    if selectedTab == 0 {
                        leaderboardContent
                    } else {
                        howItWorksContent
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 1) {
                        Text("Leaderboard")
                            .font(Font.system(size: 17, weight: .bold))
                            .foregroundColor(Color.cfDark)
                        Text(lb.currentWeekLabel)
                            .font(Font.system(size: 11))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                }
            }
        }
        .onReceive(countdownTimer) { _ in countdownText = lb.timeUntilReset }
        .onAppear { countdownText = lb.timeUntilReset }
        .alert("Enter Tournament?", isPresented: $showEntryAlert) {
            Button("Pay $20 & Enter") {
                if lb.enterTournament(appState: appState, playerName: appState.avatarName) {
                    lb.submitScore(appState: appState, playerName: appState.avatarName)
                    isEntered = true
                } else {
                    showNotEnoughCoins = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Pay $20 coins to enter this week's tournament. Prize pool grows with each entry. Scores update automatically!")
        }
        .alert("Not Enough Coins", isPresented: $showNotEnoughCoins) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You need $20 to enter. Play the Snake or Quiz games to earn more coins!")
        }
        .alert("Update Score?", isPresented: $showSubmitAlert) {
            Button("Submit Latest Scores") {
                lb.submitScore(appState: appState, playerName: appState.avatarName)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Submit your current best scores to the leaderboard.")
        }
    }

    // MARK: - Leaderboard Content
    @ViewBuilder
    private var leaderboardContent: some View {
        // Prize Podium
        PrizePodiumView(prizes: lb.topThreePrizes, entries: Array(lb.entries.prefix(3)))
            .padding(.horizontal, 16)

        // Enter / Update button
        if !isEntered {
            Button { showEntryAlert = true } label: {
                HStack(spacing: 10) {
                    Image(systemName: "trophy.fill")
                    Text("Enter This Week's Tournament  •  $20")
                        .font(Font.system(size: 16, weight: .bold))
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.cfMaroon, Color(red: 0.7, green: 0.1, blue: 0.2)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: (Color.cfMaroon as Color).opacity(0.35), radius: 10, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 16)
        } else {
            Button { showSubmitAlert = true } label: {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("Update My Scores")
                        .font(Font.system(size: 15, weight: .semibold))
                }
                .foregroundColor(Color.cfGreen)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background((Color.cfGreen as Color).opacity(0.1))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 16)
        }

        // Your rank
        if isEntered {
            YourRankCard(rank: lb.playerRank, name: appState.avatarName, totalEntries: lb.entries.count)
                .padding(.horizontal, 16)
        }

        // Full rankings list
        VStack(spacing: 10) {
            ForEach(Array(lb.entries.enumerated()), id: \.element.id) { i, entry in
                LeaderboardRow(rank: i + 1, entry: entry, isMe: entry.id == "player_me")
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - How It Works
    @ViewBuilder
    private var howItWorksContent: some View {
        VStack(spacing: 14) {
            HowItWorksCard(
                icon: "calendar.badge.clock",
                title: "Weekly Reset",
                description: "Leaderboard resets every Sunday at midnight. New week, fresh start!",
                color: Color.cfMaroon
            )
            HowItWorksCard(
                icon: "dollarsign.circle.fill",
                title: "Entry Fee & Prize Pool",
                description: "Pay $20 coins to enter. All entry fees go into the prize pool — top 3 players split it!",
                color: (Color.cfGold as Color)
            )
            HowItWorksCard(
                icon: "chart.bar.fill",
                title: "How Scores Are Calculated",
                description: "Snake Score + (Quiz Score × 10) + (Challenge Streak × 15) + (Coins ÷ 5)",
                color: Color.cfGreen
            )
            HowItWorksCard(
                icon: "trophy.fill",
                title: "Prize Distribution",
                description: "🥇 1st Place: 50% of pool\n🥈 2nd Place: 30% of pool\n🥉 3rd Place: 20% of pool",
                color: Color.orange
            )
            HowItWorksCard(
                icon: "arrow.up.circle.fill",
                title: "Update Your Score",
                description: "Play games anytime during the week and hit 'Update My Scores' to climb the ranks!",
                color: Color.blue
            )
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Reset Countdown Banner
struct ResetCountdownBanner: View {
    let timeLeft: String
    let prizePool: Int

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Resets In")
                    .font(Font.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Text(timeLeft.isEmpty ? "--:--:--" : timeLeft)
                    .font(Font.system(size: 20, weight: .black, design: .monospaced))
                    .foregroundColor(Color.cfDark)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("Prize Pool")
                    .font(Font.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor((Color.cfGold as Color))
                    Text("\(prizePool)")
                        .font(Font.system(size: 20, weight: .black))
                        .foregroundColor(Color.cfDark)
                }
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .shadow(color: (Color.black as Color).opacity(0.06), radius: 8, y: 3)
    }
}

// MARK: - Prize Podium
struct PrizePodiumView: View {
    let prizes: [Int]
    let entries: [LeaderboardEntry]

    var body: some View {
        VStack(spacing: 0) {
            // Podium steps
            HStack(alignment: .bottom, spacing: 8) {
                // 2nd
                PodiumStep(
                    rank: 2,
                    entry: entries.count > 1 ? entries[1] : nil,
                    prize: prizes.count > 1 ? prizes[1] : 0,
                    height: 80,
                    color: Color(red: 0.75, green: 0.75, blue: 0.82)
                )
                // 1st
                PodiumStep(
                    rank: 1,
                    entry: entries.first,
                    prize: prizes.first ?? 0,
                    height: 110,
                    color: (Color.cfGold as Color)
                )
                // 3rd
                PodiumStep(
                    rank: 3,
                    entry: entries.count > 2 ? entries[2] : nil,
                    prize: prizes.count > 2 ? prizes[2] : 0,
                    height: 60,
                    color: Color(red: 0.80, green: 0.55, blue: 0.35)
                )
            }
            .padding(.horizontal, 8)
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(20)
        .shadow(color: (Color.black as Color).opacity(0.07), radius: 10, y: 4)
    }
}

struct PodiumStep: View {
    let rank: Int
    let entry: LeaderboardEntry?
    let prize: Int
    let height: CGFloat
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            if let e = entry {
                Text(e.avatarEmoji)
                    .font(Font.system(size: 24))
                Text(e.name.components(separatedBy: " ").first ?? e.name)
                    .font(Font.system(size: 11, weight: .semibold))
                    .foregroundColor(Color.cfDark)
                    .lineLimit(1)
                Text("\(e.totalScore) pts")
                    .font(Font.system(size: 10))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            } else {
                Text("—")
                    .font(Font.system(size: 20))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
            // Step
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.85))
                    .frame(height: height)
                VStack(spacing: 2) {
                    Text(["🥇","🥈","🥉"][rank - 1])
                        .font(Font.system(size: 20))
                    Text("$\(prize)")
                        .font(Font.system(size: 12, weight: .black))
                        .foregroundColor(Color.white)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Your Rank Card
struct YourRankCard: View {
    let rank: Int
    let name: String
    let totalEntries: Int

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill((Color.cfMaroon as Color).opacity(0.12))
                    .frame(width: 52, height: 52)
                Text("#\(rank)")
                    .font(Font.system(size: 18, weight: .black))
                    .foregroundColor(Color.cfMaroon)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Your Rank")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Text("\(name) • \(rank) of \(totalEntries)")
                    .font(Font.system(size: 15, weight: .bold))
                    .foregroundColor(Color.cfDark)
            }
            Spacer()
            Text(rankMessage)
                .font(Font.system(size: 13))
                .foregroundColor(rankColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(14)
        .background((Color.cfMaroon as Color).opacity(0.06))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke((Color.cfMaroon as Color).opacity(0.2), lineWidth: 1)
        )
    }

    private var rankMessage: String {
        switch rank {
        case 1:        return "👑 You're #1!"
        case 2...3:    return "🏆 Top 3!"
        case 4...5:    return "🔥 Almost there!"
        default:       return "💪 Keep grinding!"
        }
    }

    private var rankColor: Color {
        switch rank {
        case 1:     return (Color.cfGold as Color)
        case 2...3: return Color.cfGreen
        default:    return Color.orange
        }
    }
}

// MARK: - Leaderboard Row
struct LeaderboardRow: View {
    let rank: Int
    let entry: LeaderboardEntry
    let isMe: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(rankBG)
                    .frame(width: 34, height: 34)
                Text(rankLabel)
                    .font(Font.system(size: rank <= 3 ? 16 : 13, weight: .black))
                    .foregroundColor(rankFG)
            }

            // Avatar emoji
            Text(entry.avatarEmoji)
                .font(Font.system(size: 22))

            // Name + score breakdown
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.name)
                    .font(Font.system(size: 14, weight: isMe ? .black : .semibold))
                    .foregroundColor(isMe ? Color.cfMaroon : Color.cfDark)
                HStack(spacing: 8) {
                    ScorePill(icon: "🐍", value: "\(entry.snakeScore)")
                    ScorePill(icon: "🧠", value: "\(entry.quizScore)/8")
                    ScorePill(icon: "🔥", value: "\(entry.challengeStreak)d")
                }
            }

            Spacer()

            // Total score
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(entry.totalScore)")
                    .font(Font.system(size: 16, weight: .black))
                    .foregroundColor(isMe ? Color.cfMaroon : Color.cfDark)
                Text("pts")
                    .font(Font.system(size: 10))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
        }
        .padding(12)
        .background(isMe ? (Color.cfMaroon as Color).opacity(0.07) : Color.cfCard)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isMe ? (Color.cfMaroon as Color).opacity(0.3) : Color.clear, lineWidth: 1.5)
        )
        .shadow(color: (Color.black as Color).opacity(isMe ? 0.08 : 0.04), radius: 6, y: 2)
    }

    private var rankLabel: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "\(rank)"
        }
    }
    private var rankBG: Color {
        switch rank {
        case 1: return (Color.cfGold as Color).opacity(0.2)
        case 2: return (Color.gray as Color).opacity(0.15)
        case 3: return (Color.orange as Color).opacity(0.15)
        default: return (Color.gray as Color).opacity(0.08)
        }
    }
    private var rankFG: Color {
        switch rank {
        case 1: return (Color.cfGold as Color)
        case 2: return Color.gray
        case 3: return Color.orange
        default: return Color(red: 0.3, green: 0.3, blue: 0.3)
        }
    }
}

struct ScorePill: View {
    let icon: String
    let value: String

    var body: some View {
        HStack(spacing: 3) {
            Text(icon).font(Font.system(size: 10))
            Text(value)
                .font(Font.system(size: 10, weight: .semibold))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }
}

// MARK: - How It Works Card
struct HowItWorksCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(Font.system(size: 22))
                .foregroundColor(color)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.system(size: 15, weight: .bold))
                    .foregroundColor(Color.cfDark)
                Text(description)
                    .font(Font.system(size: 13))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(14)
        .shadow(color: (Color.black as Color).opacity(0.05), radius: 6, y: 2)
    }
}
