// DailyChallengeView.swift
// One question per day, streak tracking, animated reveal

import SwiftUI
import Combine

struct DailyChallengeView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var dcState = DailyChallengeState()
    @State private var challenge: DailyChallenge = DailyChallengeBank.todaysChallenge()
    @State private var selectedIndex: Int? = nil
    @State private var showExplanation = false
    @State private var showRewardBurst = false
    @State private var earnedAmount = 0

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {

                    // ── Streak Banner
                    StreakBannerView(dcState: dcState)
                        .padding(.horizontal, 16)

                    // ── Next challenge countdown (if already done today)
                    if dcState.completedToday {
                        CompletedTodayCard(dcState: dcState, earnedAmount: dcState.todayEarned)
                            .padding(.horizontal, 16)
                    }

                    // ── Today's challenge card
                    VStack(alignment: .leading, spacing: 16) {

                        // Category badge + label
                        HStack(spacing: 8) {
                            Image(systemName: challenge.category.icon)
                                .font(Font.system(size: 13, weight: .semibold))
                                .foregroundColor(challenge.category.color)
                            Text(challenge.category.rawValue)
                                .font(Font.system(size: 13, weight: .bold))
                                .foregroundColor(challenge.category.color)
                            Spacer()
                            // Reward badge
                            HStack(spacing: 4) {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor((Color.cfGold as Color))
                                    .font(Font.system(size: 13))
                                Text("+$\(challenge.baseReward * dcState.streakMultiplier)")
                                    .font(Font.system(size: 13, weight: .bold))
                                    .foregroundColor((Color.cfGold as Color))
                                if dcState.streakMultiplier > 1 {
                                    Text("×\(dcState.streakMultiplier)")
                                        .font(Font.system(size: 11, weight: .black))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background((Color.orange as Color))
                                        .cornerRadius(6)
                                }
                            }
                        }

                        // Question
                        Text(challenge.question)
                            .font(Font.system(size: 18, weight: .bold))
                            .foregroundColor(Color.cfDark)
                            .fixedSize(horizontal: false, vertical: true)

                        // Answer options
                        VStack(spacing: 10) {
                            ForEach(Array(challenge.options.enumerated()), id: \.offset) { idx, option in
                                DailyChallengeOptionButton(
                                    text: option,
                                    index: idx,
                                    selectedIndex: selectedIndex,
                                    correctIndex: challenge.correctIndex,
                                    disabled: dcState.completedToday || selectedIndex != nil
                                ) {
                                    handleAnswer(idx)
                                }
                            }
                        }

                        // Explanation reveal
                        if showExplanation {
                            ExplanationCard(
                                explanation: challenge.explanation,
                                correct: selectedIndex == challenge.correctIndex
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(18)
                    .background(Color.cfCard)
                    .cornerRadius(20)
                    .shadow(color: (Color.black as Color).opacity(0.07), radius: 10, y: 4)
                    .padding(.horizontal, 16)

                    // ── Streak milestones
                    StreakMilestonesView(dcState: dcState)
                        .padding(.horizontal, 16)

                    // ── All-time stats
                    DailyStatsRow(dcState: dcState)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
                .padding(.top, 12)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 1) {
                        Text("Daily Challenge")
                            .font(Font.system(size: 17, weight: .bold))
                            .foregroundColor(Color.cfDark)
                        Text(todayLabel)
                            .font(Font.system(size: 11))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 4) {
                        Text(dcState.streakBadge)
                            .font(Font.system(size: 16))
                        Text("\(dcState.currentStreak)")
                            .font(Font.system(size: 14, weight: .black))
                            .foregroundColor(Color.cfDark)
                    }
                }
            }
        }
        // Reward burst overlay
        .overlay(alignment: .center) {
            if showRewardBurst {
                RewardBurstView(amount: earnedAmount)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.4), value: showRewardBurst)
            }
        }
        .onAppear { dcState.refreshCompletionStatus() }
    }

    // MARK: - Answer handler
    private func handleAnswer(_ idx: Int) {
        guard selectedIndex == nil, !dcState.completedToday else { return }
        selectedIndex = idx

        withAnimation(.spring(response: 0.4)) {
            showExplanation = true
        }

        let isCorrect = idx == challenge.correctIndex
        if isCorrect {
            let earned = challenge.baseReward * dcState.streakMultiplier
            earnedAmount = earned
            dcState.markCompleted(earned: earned)
            appState.addMoney(earned)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { showRewardBurst = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation { showRewardBurst = false }
                }
            }
        } else {
            // Wrong answer still marks as attempted (no reward, no streak)
            dcState.markCompleted(earned: 0)
        }
    }

    private var todayLabel: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: Date())
    }
}

// MARK: - Streak Banner
struct StreakBannerView: View {
    @ObservedObject var dcState: DailyChallengeState

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(dcState.streakBadge)
                        .font(Font.system(size: 28))
                    Text("\(dcState.currentStreak)")
                        .font(Font.system(size: 36, weight: .black))
                        .foregroundColor(Color.cfDark)
                }
                Text("day streak")
                    .font(Font.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("Next bonus at \(dcState.nextRewardAt) days")
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

                // Mini progress bar to next milestone
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill((Color.gray as Color).opacity(0.15))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(streakBarColor)
                            .frame(
                                width: geo.size.width * streakProgress,
                                height: 6
                            )
                            .animation(.spring(), value: dcState.currentStreak)
                    }
                }
                .frame(width: 120, height: 6)

                Text("×\(dcState.streakMultiplier) multiplier active")
                    .font(Font.system(size: 11, weight: .bold))
                    .foregroundColor(dcState.streakMultiplier > 1 ? Color.orange : Color(red: 0.3, green: 0.3, blue: 0.3))
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .shadow(color: (Color.black as Color).opacity(0.06), radius: 8, y: 3)
    }

    private var streakProgress: CGFloat {
        let prev: Int
        let next = dcState.nextRewardAt
        switch dcState.currentStreak {
        case 0...2:  prev = 0
        case 3...6:  prev = 3
        case 7...13: prev = 7
        default:     prev = 14
        }
        guard next > prev else { return 1.0 }
        return min(CGFloat(dcState.currentStreak - prev) / CGFloat(next - prev), 1.0)
    }

    private var streakBarColor: Color {
        switch dcState.streakMultiplier {
        case 1: return Color.cfGreen
        case 2: return Color.orange
        case 3: return Color.red
        default: return Color.purple
        }
    }
}

// MARK: - Completed Today Card
struct CompletedTodayCard: View {
    @ObservedObject var dcState: DailyChallengeState
    let earnedAmount: Int

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(Font.system(size: 32))
                .foregroundColor(Color.cfGreen)
            VStack(alignment: .leading, spacing: 4) {
                Text("Challenge Complete!")
                    .font(Font.system(size: 16, weight: .bold))
                    .foregroundColor(Color.cfDark)
                if earnedAmount > 0 {
                    Text("You earned +$\(earnedAmount) today")
                        .font(Font.system(size: 13))
                        .foregroundColor(Color.cfGreen)
                }
                Text("Come back tomorrow for a new challenge")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
            Spacer()
            // Countdown to midnight
            CountdownView()
        }
        .padding(14)
        .background((Color.cfGreen as Color).opacity(0.08))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke((Color.cfGreen as Color).opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Countdown to Midnight
struct CountdownView: View {
    @State private var timeLeft = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "clock.fill")
                .font(Font.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            Text(timeLeft)
                .font(Font.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(Color.cfDark)
        }
        .onAppear { updateTime() }
        .onReceive(timer) { _ in updateTime() }
    }

    private func updateTime() {
        let cal = Calendar.current
        guard let midnight = cal.nextDate(after: Date(), matching: DateComponents(hour: 0, minute: 0, second: 0), matchingPolicy: .nextTime) else { return }
        let diff = Int(midnight.timeIntervalSinceNow)
        let h = diff / 3600
        let m = (diff % 3600) / 60
        let s = diff % 60
        timeLeft = String(format: "%02d:%02d:%02d", h, m, s)
    }
}

// MARK: - Option Button
struct DailyChallengeOptionButton: View {
    let text: String
    let index: Int
    let selectedIndex: Int?
    let correctIndex: Int
    let disabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(["A","B","C","D"][min(index, 3)])
                    .font(Font.system(size: 13, weight: .black))
                    .foregroundColor(letterFG)
                    .frame(width: 28, height: 28)
                    .background(letterBG)
                    .clipShape(Circle())

                Text(text)
                    .font(Font.system(size: 15, weight: .semibold))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.leading)

                Spacer()

                if let sel = selectedIndex {
                    if index == correctIndex {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.cfGreen)
                    } else if index == sel {
                        Image(systemName: "xmark.circle.fill").foregroundColor(Color.red)
                    }
                }
            }
            .padding(14)
            .background(bgColor)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: 1.5))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(disabled)
    }

    private var answered: Bool { selectedIndex != nil }
    private var isCorrect: Bool { index == correctIndex }
    private var isSelected: Bool { selectedIndex == index }

    private var bgColor: Color {
        guard answered else { return Color.cfCard }
        if isCorrect  { return (Color.cfGreen as Color).opacity(0.12) }
        if isSelected { return (Color.red as Color).opacity(0.1) }
        return (Color.gray as Color).opacity(0.05)
    }
    private var borderColor: Color {
        guard answered else { return (Color.gray as Color).opacity(0.2) }
        if isCorrect  { return Color.cfGreen }
        if isSelected { return Color.red }
        return (Color.gray as Color).opacity(0.1)
    }
    private var textColor: Color {
        guard answered else { return Color.cfDark }
        if isCorrect  { return Color.cfGreen }
        if isSelected { return Color.red }
        return (Color.gray as Color).opacity(0.5)
    }
    private var letterFG: Color {
        guard answered else { return Color.cfDark }
        if isCorrect  { return Color.cfGreen }
        if isSelected { return Color.red }
        return (Color.gray as Color).opacity(0.4)
    }
    private var letterBG: Color {
        guard answered else { return (Color.gray as Color).opacity(0.1) }
        if isCorrect  { return (Color.cfGreen as Color).opacity(0.15) }
        if isSelected { return (Color.red as Color).opacity(0.1) }
        return (Color.gray as Color).opacity(0.06)
    }
}

// MARK: - Explanation Card
struct ExplanationCard: View {
    let explanation: String
    let correct: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: correct ? "lightbulb.fill" : "info.circle.fill")
                .foregroundColor(correct ? (Color.cfGold as Color) : Color.blue)
                .font(Font.system(size: 18))
            VStack(alignment: .leading, spacing: 4) {
                Text(correct ? "Great job! 💡" : "Here's what to know:")
                    .font(Font.system(size: 13, weight: .bold))
                    .foregroundColor(Color.cfDark)
                Text(explanation)
                    .font(Font.system(size: 13))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .background(correct ? (Color.cfGold as Color).opacity(0.08) : (Color.blue as Color).opacity(0.07))
        .cornerRadius(12)
    }
}

// MARK: - Streak Milestones
struct StreakMilestonesView: View {
    @ObservedObject var dcState: DailyChallengeState

    let milestones: [(Int, String, String)] = [
        (3,  "🔥", "3-Day"),
        (7,  "⚡️", "1 Week"),
        (14, "🏆", "2 Weeks"),
        (30, "💎", "Month"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Streak Milestones")
                .font(Font.system(size: 15, weight: .bold))
                .foregroundColor(Color.cfDark)
            HStack(spacing: 10) {
                ForEach(milestones, id: \.0) { day, emoji, label in
                    let achieved = dcState.currentStreak >= day
                    VStack(spacing: 4) {
                        Text(emoji)
                            .font(Font.system(size: 24))
                            .opacity(achieved ? 1.0 : 0.3)
                        Text(label)
                            .font(Font.system(size: 10, weight: .semibold))
                            .foregroundColor(achieved ? Color.cfDark : Color(red: 0.3, green: 0.3, blue: 0.3))
                        Text("×\(milestoneMultiplier(day))")
                            .font(Font.system(size: 10, weight: .black))
                            .foregroundColor(achieved ? (Color.orange as Color) : Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(achieved ? (Color.cfGold as Color).opacity(0.1) : (Color.gray as Color).opacity(0.06))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(achieved ? (Color.cfGold as Color).opacity(0.4) : Color.clear, lineWidth: 1.5)
                    )
                }
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .shadow(color: (Color.black as Color).opacity(0.05), radius: 6, y: 2)
    }

    private func milestoneMultiplier(_ day: Int) -> Int {
        switch day {
        case 3:  return 2
        case 7:  return 3
        case 14: return 4
        default: return 5
        }
    }
}

// MARK: - Stats Row
struct DailyStatsRow: View {
    @ObservedObject var dcState: DailyChallengeState

    var body: some View {
        HStack(spacing: 12) {
            MiniStatBox(value: "\(dcState.totalChallengesCompleted)", label: "Completed", color: Color.cfGreen)
            MiniStatBox(value: "\(dcState.longestStreak)", label: "Best Streak", color: Color.cfMaroon)
            MiniStatBox(value: "×\(dcState.streakMultiplier)", label: "Multiplier", color: (Color.orange as Color))
        }
    }
}

struct MiniStatBox: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(Font.system(size: 22, weight: .black))
                .foregroundColor(color)
            Text(label)
                .font(Font.system(size: 11, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
}

// MARK: - Reward Burst Overlay
struct RewardBurstView: View {
    let amount: Int
    @State private var scale: CGFloat = 0.4
    @State private var opacity: Double = 0

    var body: some View {
        VStack(spacing: 8) {
            Text("🎉")
                .font(Font.system(size: 52))
            Text("+$\(amount)")
                .font(Font.system(size: 36, weight: .black))
                .foregroundColor(Color.white)
            Text("Added to your wallet!")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.85))
        }
        .padding(32)
        .background((Color.cfGreen as Color).opacity(0.95))
        .cornerRadius(24)
        .shadow(color: (Color.black as Color).opacity(0.3), radius: 20, y: 8)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
