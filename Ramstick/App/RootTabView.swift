

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var a11y: AccessibilityManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            // 0. AI Study Buddy
            AIStudyBuddyView()
                .environmentObject(appState)
                .environmentObject(a11y)
                .tabItem {
                    Label("AI Buddy", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(0)

            // 1. Games Hub
            GamesHubView()
                .environmentObject(appState)
                .environmentObject(a11y)
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }
                .tag(1)

            // 2. Daily Challenge
            DailyChallengeView()
                .environmentObject(appState)
                .environmentObject(a11y)
                .tabItem {
                    Label("Challenge", systemImage: "bolt.fill")
                }
                .tag(2)

            // 3. Opportunities
            OpportunitiesView()
                .environmentObject(appState)
                .environmentObject(a11y)
                .tabItem {
                    Label("Earn", systemImage: "star.fill")
                }
                .tag(3)

            // 4. Leaderboard
            LeaderboardView()
                .environmentObject(appState)
                .environmentObject(a11y)
                .tabItem {
                    Label("Ranks", systemImage: "trophy.fill")
                }
                .tag(4)

            // 5. Profile
            ProfileView()
                .environmentObject(appState)
                .environmentObject(a11y)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
                .tag(5)
        }
        .accentColor(Color.cfMaroon)
    }
}
