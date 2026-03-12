

import SwiftUI

@main
struct CampusFlowApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var a11y = AccessibilityManager()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                RootTabView()
                    .environmentObject(appState)
                    .environmentObject(a11y)
            } else {
                OnboardingView()
                    .environmentObject(appState)
                    .environmentObject(a11y)
            }
        }
    }
}
