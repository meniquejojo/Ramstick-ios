
import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var appState: AppState
    @State private var showTrash = false
    @State private var showQuiz  = false
    @State private var showSnake = false

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    balanceBanner
                    sectionHeader

                    // ── FEATURED: Trash Catcher
                    FeaturedGameCard(
                        title:       "Trash Catcher",
                        subtitle:    "Drag your bin to catch falling trash. Dodge the toxic waste!",
                        emoji:       "🗑️",
                        tag:         "NEW",
                        tagColor:    Color.cfGreen,
                        accentColor: Color.cfGreen,
                        details: [
                            "← Drag to move bin →",
                            "♻️ Recyclables  +$8",
                            "☢️ Toxic waste  −$12",
                            "Speed up each level!"
                        ],
                        highScore: appState.snakeHighScore,
                        action: { showTrash = true }
                    )
                    .padding(.horizontal, 16)

                    // ── Quiz
                    TCGameRow(
                        title: "Quiz",
                        subtitle: "Math • World Knowledge • HT Facts",
                        emoji: "🧠",
                        accentColor: Color.cfMaroon,
                        note: "Best: \(appState.quizHighScore)/8 correct"
                    ) { showQuiz = true }
                    .padding(.horizontal, 16)

                    // ── Classic Snake (bonus)
                    TCGameRow(
                        title: "EcoSnake",
                        subtitle: "Classic snake with eco pickups",
                        emoji: "🐍",
                        accentColor: Color.blue,
                        note: "High score: \(appState.snakeHighScore)"
                    ) { showSnake = true }
                    .padding(.horizontal, 16)

                    earnTips
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)
                }
                .padding(.top, 12)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Games")
                        .font(Font.system(size: 18, weight: .bold))
                        .foregroundColor(Color.cfDark)
                }
            }
        }
        .fullScreenCover(isPresented: $showTrash) { TrashCatcherView().environmentObject(appState) }
        .fullScreenCover(isPresented: $showQuiz)  { QuizGameView().environmentObject(appState)     }
        .fullScreenCover(isPresented: $showSnake) { SnakeGameView().environmentObject(appState)    }
    }

    // MARK: Sub-views
    private var balanceBanner: some View {
        HStack(spacing: 14) {
            Image(systemName: "dollarsign.circle.fill")
                .font(Font.system(size: 32))
                .foregroundColor(Color.cfGold)
            VStack(alignment: .leading, spacing: 2) {
                Text("Your Balance")
                    .font(Font.system(size: 13))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Text("$\(appState.money)")
                    .font(Font.system(size: 26, weight: .bold))
                    .foregroundColor(Color.cfDark)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("Best Score")
                    .font(Font.system(size: 12))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                Text("\(appState.snakeHighScore)")
                    .font(Font.system(size: 20, weight: .black))
                    .foregroundColor(Color.cfGreen)
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(16)
        .shadow(color: (Color.black as Color).opacity(0.07), radius: 8, y: 3)
        .padding(.horizontal, 16)
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("🎮  Choose a Game")
                .font(Font.system(size: 20, weight: .bold))
                .foregroundColor(Color.cfDark)
            Text("Earn coins  →  unlock real opportunities")
                .font(Font.system(size: 13))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }

    private var earnTips: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("💡  How to Earn Coins")
                .font(Font.system(size: 14, weight: .bold))
                .foregroundColor(Color.cfDark)
            VStack(alignment: .leading, spacing: 6) {
                GHTipRow(icon: "🗑️", text: "Trash Catcher: +$4–$8 per item caught")
                GHTipRow(icon: "☢️", text: "Avoid toxic waste — you lose $12!")
                GHTipRow(icon: "🔥", text: "5-catch streak gives a +$10 bonus")
                GHTipRow(icon: "🧠", text: "Quiz: each correct answer = +$10")
                GHTipRow(icon: "⚡️", text: "Daily Challenge: streak multipliers up to ×4")
                GHTipRow(icon: "🗺️", text: "Explore campus buildings for +$5–$12")
            }
        }
        .padding(16)
        .background((Color.cfGreen as Color).opacity(0.07))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke((Color.cfGreen as Color).opacity(0.2), lineWidth: 1))
    }
}

// MARK: - Featured Card
struct FeaturedGameCard: View {
    let title: String
    let subtitle: String
    let emoji: String
    let tag: String
    let tagColor: Color
    let accentColor: Color
    let details: [String]
    let highScore: Int
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(accentColor.opacity(0.12))
                            .frame(width: 66, height: 66)
                        Text(emoji).font(Font.system(size: 34))
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 8) {
                            Text(title)
                                .font(Font.system(size: 18, weight: .bold))
                                .foregroundColor(Color.cfDark)
                            Text(tag)
                                .font(Font.system(size: 9, weight: .black))
                                .foregroundColor(Color.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(tagColor)
                                .cornerRadius(5)
                        }
                        Text(subtitle)
                            .font(Font.system(size: 13))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                            .lineLimit(2)
                    }
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .font(Font.system(size: 32))
                        .foregroundColor(accentColor)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                    ForEach(details, id: \.self) { d in
                        Text(d)
                            .font(Font.system(size: 11, weight: .medium))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background((Color.gray as Color).opacity(0.07))
                            .cornerRadius(8)
                    }
                }

                HStack {
                    Image(systemName: "trophy.fill").font(Font.system(size: 12)).foregroundColor(Color.cfGold)
                    Text("Best: \(highScore)").font(Font.system(size: 12, weight: .semibold)).foregroundColor(Color.cfGold)
                    Spacer()
                    Text("Tap to play →").font(Font.system(size: 12, weight: .semibold)).foregroundColor(accentColor)
                }
            }
            .padding(16)
            .background(Color.cfCard)
            .cornerRadius(22)
            .shadow(color: accentColor.opacity(0.18), radius: 12, y: 5)
            .scaleEffect(pressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.spring(response: 0.2)) { pressed = true  } }
                .onEnded   { _ in withAnimation(.spring(response: 0.2)) { pressed = false } }
        )
    }
}

// MARK: - Regular Game Row
struct TCGameRow: View {
    let title: String
    let subtitle: String
    let emoji: String
    let accentColor: Color
    let note: String
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14).fill(accentColor.opacity(0.10)).frame(width: 58, height: 58)
                    Text(emoji).font(Font.system(size: 28))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(Font.system(size: 17, weight: .bold)).foregroundColor(Color.cfDark)
                    Text(subtitle).font(Font.system(size: 12)).foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3)).lineLimit(1)
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill").font(Font.system(size: 10)).foregroundColor(Color.cfGold)
                        Text(note).font(Font.system(size: 11, weight: .semibold)).foregroundColor(Color.cfGold)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right.circle.fill").font(Font.system(size: 24)).foregroundColor(accentColor)
            }
            .padding(14)
            .background(Color.cfCard)
            .cornerRadius(18)
            .shadow(color: (Color.black as Color).opacity(0.06), radius: 8, y: 3)
            .scaleEffect(pressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.spring(response: 0.2)) { pressed = true  } }
                .onEnded   { _ in withAnimation(.spring(response: 0.2)) { pressed = false } }
        )
    }
}

struct GHTipRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon).font(Font.system(size: 13))
            Text(text).font(Font.system(size: 12)).foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
    }
}
