

import SwiftUI

// MARK: - Onboarding Data
 struct OnboardingPage {
    let emoji:       String
    let title:       String
    let subtitle:    String
    let bullets:     [String]
    let accentColor: Color
}

 let pages: [OnboardingPage] = [
    OnboardingPage(
        emoji: "🏛️",
        title: "Welcome to\nRamstick",
        subtitle: "Your HT student success app — built for Ramblers, by Ramblers.",
        bullets: ["Earn coins for campus engagement", "Unlock real scholarships & opportunities", "Get AI-powered academic help"],
        accentColor: Color.cfMaroon
    ),
    OnboardingPage(
        emoji: "🤖",
        title: "Meet Your\nAI Study Buddy",
        subtitle: "Powered by AI — always available, always in your corner.",
        bullets: ["Academic advising & degree planning", "Essay coaching for scholarships", "Find the right HT office instantly"],
        accentColor: Color.blue
    ),
    OnboardingPage(
        emoji: "🎮",
        title: "Learn While\nYou Play",
        subtitle: "Earn coins through games, quizzes, and daily challenges.",
        bullets: ["Trash Catcher — clean up campus", "Quiz categories: Math, HT Facts, Career", "Daily streaks multiply your earnings"],
        accentColor: Color.cfGreen
    ),
    OnboardingPage(
        emoji: "💼",
        title: "Unlock Real\nOpportunities",
        subtitle: "Spend your coins to access scholarships, internships & more.",
        bullets: ["Step-by-step application checklists", "Ready-to-send email templates", "AI coach for every application"],
        accentColor: Color.cfGold
    ),
]

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Background — shifts color per page
            pages[currentPage].accentColor
                .opacity(0.12)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.4), value: currentPage)

            // Dark base
            Color(red: 0.07, green: 0.05, blue: 0.10)
                .ignoresSafeArea()
                .opacity(0.92)

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation(.spring(response: 0.4)) {
                                currentPage = pages.count - 1
                            }
                        }
                        .font(Font.system(size: 15, weight: .medium))
                        .foregroundColor((Color.white as Color).opacity(0.45))
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    } else {
                        Color.clear.frame(height: 44)
                            .padding(.top, 16)
                    }
                }

                Spacer()

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { i, page in
                        OnboardingPageView(page: page, isActive: currentPage == i)
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.45, dampingFraction: 0.8), value: currentPage)

                Spacer()

                // Dots + button
                VStack(spacing: 28) {
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { i in
                            Capsule()
                                .fill(i == currentPage
                                      ? pages[currentPage].accentColor
                                      : (Color.white as Color).opacity(0.25))
                                .frame(width: i == currentPage ? 24 : 8, height: 8)
                                .animation(.spring(response: 0.35), value: currentPage)
                        }
                    }

                    // CTA button
                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation(.spring(response: 0.4)) {
                                currentPage += 1
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                hasCompletedOnboarding = true
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text(currentPage < pages.count - 1 ? "Next" : "Let's Go 🚀")
                                .font(Font.system(size: 18, weight: .bold))
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(Font.system(size: 16, weight: .bold))
                            }
                        }
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [
                                    pages[currentPage].accentColor,
                                    pages[currentPage].accentColor.opacity(0.75)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: pages[currentPage].accentColor.opacity(0.45),
                                radius: 14, y: 6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 28)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
                .padding(.bottom, 52)
            }
        }
    }
}

// MARK: - Single Page
struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            // Emoji in glowing circle
            ZStack {
                Circle()
                    .fill(page.accentColor.opacity(0.15))
                    .frame(width: 130, height: 130)
                Circle()
                    .fill(page.accentColor.opacity(0.08))
                    .frame(width: 160, height: 160)
                Text(page.emoji)
                    .font(Font.system(size: 64))
                    .scaleEffect(appeared ? 1.0 : 0.6)
                    .opacity(appeared ? 1 : 0)
            }
            .padding(.bottom, 32)

            // Title
            Text(page.title)
                .font(Font.system(size: 34, weight: .black))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .offset(y: appeared ? 0 : 20)
                .opacity(appeared ? 1 : 0)
                .padding(.bottom, 14)

            // Subtitle
            Text(page.subtitle)
                .font(Font.system(size: 16))
                .foregroundColor((Color.white as Color).opacity(0.65))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .offset(y: appeared ? 0 : 16)
                .opacity(appeared ? 1 : 0)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)

            // Bullet points
            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(page.bullets.enumerated()), id: \.offset) { i, bullet in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(page.accentColor.opacity(0.2))
                                .frame(width: 28, height: 28)
                            Image(systemName: "checkmark")
                                .font(Font.system(size: 12, weight: .bold))
                                .foregroundColor(page.accentColor)
                        }
                        Text(bullet)
                            .font(Font.system(size: 15, weight: .medium))
                            .foregroundColor((Color.white as Color).opacity(0.85))
                        Spacer()
                    }
                    .offset(x: appeared ? 0 : -30)
                    .opacity(appeared ? 1 : 0)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.75)
                        .delay(0.1 + Double(i) * 0.08),
                        value: appeared
                    )
                }
            }
            .padding(.horizontal, 36)
        }
        .onAppear {
            if isActive {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.72).delay(0.05)) {
                    appeared = true
                }
            }
        }
        .onChange(of: isActive) { active in
            if active {
                appeared = false
                withAnimation(.spring(response: 0.55, dampingFraction: 0.72).delay(0.05)) {
                    appeared = true
                }
            }
        }
    }
}
