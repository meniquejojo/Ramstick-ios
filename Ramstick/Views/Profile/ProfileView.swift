

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var a11y: AccessibilityManager
    @State private var showNameEditor  = false
    @State private var tempName        = ""
    @State private var showA11y        = false

    let avatarColors: [(Color, String)] = [
        (Color.cfMaroon,                              "Maroon"),
        (Color.cfGreen,                               "Forest"),
        (Color.blue,                                  "Blue"),
        (Color(red: 0.4, green: 0.2, blue: 0.6),     "Purple"),
        (Color.orange,                                "Orange"),
        (Color(red: 0.15, green: 0.15, blue: 0.15),  "Black"),
    ]

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    avatarCard
                    customizationCard
                    statsCard
                    if !appState.unlockedOpportunityIDs.isEmpty {
                        unlockedBadge
                    }
                    accessibilityButton
                    resetButton
                }
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(Color.cfBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Profile")
                        .font(Font.system(size: 18, weight: .bold))
                        .foregroundColor(Color.cfDark)
                }
            }
        }
        .alert("Edit Name", isPresented: $showNameEditor) {
            TextField("Your name", text: $tempName)
            Button("Save") {
                let trimmed = tempName.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty { appState.avatarName = trimmed }
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showA11y) {
            AccessibilitySettingsView()
                .environmentObject(a11y)
        }
    }

    // MARK: - Avatar Card
    private var avatarCard: some View {
        VStack(spacing: 16) {
            StickmanAvatarView(
                size: 110,
                bodyColor: appState.avatarBodyColor,
                accessory: appState.avatarHeadAccessory,
                animated: true
            )
            .padding(.top, 20)

            Text(appState.avatarName)
                .font(Font.system(size: 22, weight: .bold))
                .foregroundColor(Color.cfDark)

            Text("Huston-Tillotson University")
                .font(Font.system(size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))

            Button {
                tempName = appState.avatarName
                showNameEditor = true
            } label: {
                Label("Edit Name", systemImage: "pencil")
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(Color.cfMaroon)
            }
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color.cfCard)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.07), radius: 10, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Customization Card
    private var customizationCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("🎨  Customize Avatar")
                .font(Font.system(size: 16, weight: .bold))
                .foregroundColor(Color.cfDark)

            VStack(alignment: .leading, spacing: 10) {
                Text("Body Color")
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                HStack(spacing: 12) {
                    ForEach(avatarColors, id: \.1) { pair in
                        ColorCircle(
                            color: pair.0,
                            isSelected: appState.avatarBodyColor == pair.0
                        ) {
                            withAnimation(.spring()) { appState.avatarBodyColor = pair.0 }
                        }
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("Head Accessory")
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(AvatarAccessory.allCases) { acc in
                            AccessoryChip(
                                accessory: acc,
                                isSelected: appState.avatarHeadAccessory == acc
                            ) {
                                withAnimation(.spring()) { appState.avatarHeadAccessory = acc }
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        .padding(.horizontal, 16)
    }

    // MARK: - Stats Card
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("📊  Your Stats")
                .font(Font.system(size: 16, weight: .bold))
                .foregroundColor(Color.cfDark)

            HStack(spacing: 14) {
                StatCard(title: "Balance",     value: "$\(appState.money)",             icon: "dollarsign.circle.fill", color: Color.cfGold)
                StatCard(title: "Snake Best",  value: "\(appState.snakeHighScore)",      icon: "trophy.fill",            color: Color.cfGreen)
            }
            HStack(spacing: 14) {
                StatCard(title: "Quiz Best",   value: "\(appState.quizHighScore)/8",     icon: "brain.head.profile",     color: Color.cfMaroon)
                StatCard(title: "Trash Saved", value: "\(appState.totalTrashCollected)", icon: "trash.circle.fill",      color: Color.blue)
            }
        }
        .padding(16)
        .background(Color.cfCard)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        .padding(.horizontal, 16)
    }

    // MARK: - Unlocked Banner
    private var unlockedBadge: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🔓  Unlocked Opportunities")
                .font(Font.system(size: 16, weight: .bold))
                .foregroundColor(Color.cfDark)
            Text("\(appState.unlockedOpportunityIDs.count) opportunity(ies) unlocked")
                .font(Font.system(size: 14))
                .foregroundColor(Color.cfGreen)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cfGreen.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cfGreen.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }

    // MARK: - Accessibility Button
    private var accessibilityButton: some View {
        Button {
            showA11y = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.cfMaroon.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "accessibility")
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundColor(Color.cfMaroon)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Accessibility")
                        .font(Font.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.cfDark)
                    Text("High contrast, text size, magnification, read aloud")
                        .font(Font.system(size: 12))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
            }
            .padding(16)
            .background(Color.cfCard)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button {
            appState.money               = 150
            appState.snakeHighScore      = 0
            appState.quizHighScore       = 0
            appState.totalTrashCollected = 0
            appState.totalQuizCorrect    = 0
            appState.unlockedOpportunityIDs = []
        } label: {
            Label("Reset All Progress", systemImage: "arrow.counterclockwise")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundColor(Color.red.opacity(0.7))
        }
        .padding(.top, 4)
    }
}

// MARK: - ColorCircle
struct ColorCircle: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 38, height: 38)
                    .shadow(color: color.opacity(0.4), radius: 4, y: 2)
                if isSelected {
                    Circle()
                        .stroke(Color.white, lineWidth: 2.5)
                        .frame(width: 38, height: 38)
                    Image(systemName: "checkmark")
                        .font(Font.system(size: 13, weight: .black))
                        .foregroundColor(Color.white)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - AccessoryChip
struct AccessoryChip: View {
    let accessory: AvatarAccessory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(accessory.rawValue)
                .font(Font.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? Color.white : Color.cfDark)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.cfMaroon : Color.cfBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isSelected ? Color.cfMaroon : Color.gray.opacity(0.25),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - StatCard
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(Font.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(Font.system(size: 22, weight: .black))
                .foregroundColor(Color.cfDark)
            Text(title)
                .font(Font.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.07))
        .cornerRadius(14)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
        .environmentObject(AccessibilityManager())
}
