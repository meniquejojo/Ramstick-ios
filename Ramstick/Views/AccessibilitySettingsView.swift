

import SwiftUI

struct AccessibilitySettingsView: View {
    @EnvironmentObject var a11y: AccessibilityManager
    @Environment(\.dismiss) var dismiss
    @State private var showResetConfirm = false

    var body: some View {
        NavigationView {
            ZStack {
                (a11y.highContrast ? Color.black : Color.cfBackground)
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {

                        // ── VISION ──
                        sectionHeader("👁 Vision")

                        // High Contrast
                        settingCard {
                            VStack(spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("High Contrast Mode")
                                            .font(.system(size: a11y.fontSize(16), weight: .bold))
                                            .foregroundColor(a11y.primaryText)
                                        Text("Increases contrast for easier reading")
                                            .font(.system(size: a11y.fontSize(12)))
                                            .foregroundColor(a11y.primaryText)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $a11y.highContrast)
                                        .labelsHidden()
                                        .tint(Color.cfMaroon)
                                }

                                // Preview chips
                                HStack(spacing: 8) {
                                    contrastChip("Normal", bg: Color.cfCard,  fg: Color.cfDark, active: !a11y.highContrast)
                                    contrastChip("High",   bg: Color.black,   fg: Color.white,  active:  a11y.highContrast)
                                }
                            }
                        }

                        // Text Size
                        settingCard {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Text Size")
                                            .font(.system(size: a11y.fontSize(16), weight: .bold))
                                            .foregroundColor(a11y.primaryText)
                                        Text("Scale: \(Int(a11y.textScale * 100))%")
                                            .font(.system(size: a11y.fontSize(12)))
                                            .foregroundColor(a11y.primaryText)
                                    }
                                    Spacer()
                                    // Quick buttons
                                    HStack(spacing: 6) {
                                        ForEach([("S", 0.85), ("M", 1.0), ("L", 1.25), ("XL", 1.5)], id: \.0) { label, val in
                                            Button {
                                                withAnimation(.spring(response: 0.3)) { a11y.textScale = val }
                                            } label: {
                                                Text(label)
                                                    .font(.system(size: 12, weight: .bold))
                                                    .foregroundColor(abs(a11y.textScale - val) < 0.01 ? .white : Color.cfMaroon)
                                                    .frame(width: 32, height: 32)
                                                    .background(abs(a11y.textScale - val) < 0.01 ? Color.cfMaroon : Color.cfMaroon.opacity(0.12))
                                                    .cornerRadius(8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }

                                Slider(value: $a11y.textScale, in: 0.8...2.0, step: 0.05)
                                    .tint(Color.cfMaroon)

                                // Live preview
                                HStack {
                                    Text("Preview: ")
                                        .font(.system(size: a11y.fontSize(14)))
                                        .foregroundColor(a11y.primaryText)
                                    Text("Ramstick 🏛️")
                                        .font(.system(size: a11y.fontSize(14), weight: .bold))
                                        .foregroundColor(a11y.primaryText)
                                }
                                .animation(.spring(response: 0.3), value: a11y.textScale)
                            }
                        }

                        // Magnification
                        settingCard {
                            VStack(spacing: 14) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Screen Magnification")
                                            .font(.system(size: a11y.fontSize(16), weight: .bold))
                                            .foregroundColor(a11y.primaryText)
                                        Text("Pinch to zoom any screen.\nDouble-tap to reset zoom.")
                                            .font(.system(size: a11y.fontSize(12)))
                                            .foregroundColor(a11y.primaryText)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $a11y.magnificationEnabled)
                                        .labelsHidden()
                                        .tint(Color.cfMaroon)
                                }

                                if a11y.magnificationEnabled {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Max zoom: \(String(format: "%.1f", a11y.magnifyLevel))×")
                                            .font(.system(size: a11y.fontSize(12)))
                                            .foregroundColor(a11y.primaryText)
                                        Slider(value: $a11y.magnifyLevel, in: 1.2...3.0, step: 0.1)
                                            .tint(Color.cfMaroon)
                                    }
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }

                        // ── AUDIO ──
                        sectionHeader("🔊 Audio")

                        settingCard {
                            VStack(spacing: 14) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Read Aloud")
                                            .font(.system(size: a11y.fontSize(16), weight: .bold))
                                            .foregroundColor(a11y.primaryText)
                                        Text("Tap the speaker icon next to text to hear it read out loud.")
                                            .font(.system(size: a11y.fontSize(12)))
                                            .foregroundColor(a11y.primaryText)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    Spacer()
                                    Toggle("", isOn: $a11y.readAloudEnabled)
                                        .labelsHidden()
                                        .tint(Color.cfMaroon)
                                }

                                if a11y.readAloudEnabled {
                                    HStack(spacing: 10) {
                                        Image(systemName: "speaker.wave.2.circle.fill")
                                            .foregroundColor(Color.cfGold)
                                            .font(.system(size: 18))
                                        Text("Tap the icon below to test it")
                                            .font(.system(size: a11y.fontSize(13)))
                                            .foregroundColor(a11y.primaryText)
                                        Spacer()
                                        SpeakButton(text: "Welcome to Ramstick. Read aloud is now enabled.")
                                            .environmentObject(a11y)
                                    }
                                    .padding(12)
                                    .background(Color.cfGold.opacity(0.1))
                                    .cornerRadius(10)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                                }
                            }
                        }

                        // ── SYSTEM ──
                        sectionHeader("📱 iOS Accessibility")

                        settingCard {
                            VStack(spacing: 14) {
                                Text("Ramstick also works with these iOS built-in features:")
                                    .font(.system(size: a11y.fontSize(13)))
                                    .foregroundColor(a11y.primaryText)
                                    .fixedSize(horizontal: false, vertical: true)

                                let tips: [(String, String, String)] = [
                                    ("VoiceOver",    "All buttons and text are labeled",          "accessibility"),
                                    ("Dynamic Type", "Respects iOS system text size setting",     "textformat.size"),
                                    ("Reduce Motion","Respects iOS Reduce Motion setting",        "waveform.path"),
                                    ("Bold Text",    "Responds to iOS Bold Text display setting", "bold"),
                                ]
                                ForEach(tips, id: \.0) { title, desc, icon in
                                    HStack(spacing: 12) {
                                        Image(systemName: icon)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.cfMaroon)
                                            .frame(width: 28)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(title)
                                                .font(.system(size: a11y.fontSize(13), weight: .semibold))
                                                .foregroundColor(a11y.primaryText)
                                            Text(desc)
                                                .font(.system(size: a11y.fontSize(11)))
                                                .foregroundColor(a11y.primaryText)
                                        }
                                        Spacer()
                                    }
                                }

                                Button {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "gear")
                                        Text("Open iOS Accessibility Settings")
                                            .font(.system(size: a11y.fontSize(14), weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.cfMaroon)
                                    .cornerRadius(12)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

                        // Reset button
                        Button {
                            showResetConfirm = true
                        } label: {
                            Text("Reset to Defaults")
                                .font(.system(size: a11y.fontSize(14), weight: .semibold))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.red.opacity(0.08))
                                .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Accessibility")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.cfMaroon)
                }
            }
            .alert("Reset Accessibility Settings?", isPresented: $showResetConfirm) {
                Button("Reset", role: .destructive) { a11y.resetToDefaults() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will restore all accessibility settings to their defaults.")
            }
        }
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: a11y.fontSize(13), weight: .black))
                .foregroundColor(a11y.highContrast ? .yellow : Color.cfMaroon)
                .kerning(1.5)
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.top, 6)
    }

    @ViewBuilder
    private func settingCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack { content() }
            .padding(16)
            .background(a11y.cardBG)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(a11y.highContrast ? Color.white.opacity(0.3) : Color.clear, lineWidth: 1)
            )
    }

    @ViewBuilder
    private func contrastChip(_ label: String, bg: Color, fg: Color, active: Bool) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(active ? Color.cfMaroon : Color.gray.opacity(0.3))
                .frame(width: 10, height: 10)
            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(fg)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(bg)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(active ? Color.cfMaroon : Color.gray.opacity(0.3), lineWidth: active ? 2 : 1)
        )
    }
}
