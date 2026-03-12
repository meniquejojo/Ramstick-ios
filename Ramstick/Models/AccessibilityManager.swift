

import SwiftUI
import AVFoundation
import Combine

// MARK: - Accessibility Manager
final class AccessibilityManager: ObservableObject {

    // ── High Contrast ──
    @Published var highContrast: Bool = UserDefaults.standard.bool(forKey: "a11y_highContrast") {
        didSet { UserDefaults.standard.set(highContrast, forKey: "a11y_highContrast") }
    }

    // ── Text Scale ──
    @Published var textScale: Double = UserDefaults.standard.double(forKey: "a11y_textScale") == 0
        ? 1.0
        : UserDefaults.standard.double(forKey: "a11y_textScale") {
        didSet {
            let clamped = min(2.0, max(0.8, textScale))
            if clamped != textScale { textScale = clamped; return }
            UserDefaults.standard.set(textScale, forKey: "a11y_textScale")
        }
    }

    // ── Read Aloud ──
    @Published var readAloudEnabled: Bool = UserDefaults.standard.bool(forKey: "a11y_readAloud") {
        didSet { UserDefaults.standard.set(readAloudEnabled, forKey: "a11y_readAloud") }
    }

    // ── Magnification ──
    @Published var magnificationEnabled: Bool = UserDefaults.standard.bool(forKey: "a11y_magnification") {
        didSet { UserDefaults.standard.set(magnificationEnabled, forKey: "a11y_magnification") }
    }

    @Published var magnifyLevel: Double = UserDefaults.standard.double(forKey: "a11y_magnifyLevel") == 0
        ? 1.5
        : UserDefaults.standard.double(forKey: "a11y_magnifyLevel") {
        didSet {
            let clamped = min(3.0, max(1.2, magnifyLevel))
            if clamped != magnifyLevel { magnifyLevel = clamped; return }
            UserDefaults.standard.set(magnifyLevel, forKey: "a11y_magnifyLevel")
        }
    }

    private let synthesizer = AVSpeechSynthesizer()

    // MARK: - Derived Colors (high contrast overrides)
    var primaryText: Color   { highContrast ? .white                               : Color.cfDark }
    var secondaryText: Color { highContrast ? Color(white: 0.85)                   : Color(red: 0.3, green: 0.3, blue: 0.3)}
    var cardBG: Color        { highContrast ? .black                               : Color.cfCard }
    var appBG: Color         { highContrast ? .black                               : Color.cfBackground }
    var accentColor: Color   { highContrast ? .yellow                              : Color.cfGold }
    var maroon: Color        { highContrast ? Color(red: 1, green: 0.2, blue: 0.2) : Color.cfMaroon }

    // MARK: - Font scaling helper
    func fontSize(_ base: CGFloat) -> CGFloat {
        base * CGFloat(textScale)
    }

    // MARK: - Read Aloud
    func speak(_ text: String) {
        guard readAloudEnabled else { return }
        stopSpeaking()

        // Activate audio session so speech works on a real device
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSession error: \(error)")
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate  = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }

    func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        // Deactivate session after stopping
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: - Reset all to defaults
    func resetToDefaults() {
        highContrast         = false
        textScale            = 1.0
        readAloudEnabled     = false
        magnificationEnabled = false
        magnifyLevel         = 1.5
    }
}

// MARK: - MagnifiableView
struct MagnifiableView<Content: View>: View {
    @EnvironmentObject var a11y: AccessibilityManager
    let content: Content

    @State private var scale: CGFloat     = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize     = .zero
    @State private var lastOffset: CGSize = .zero

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if a11y.magnificationEnabled {
            content
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { val in
                            let delta = val / lastScale
                            lastScale = val
                            scale = min(CGFloat(a11y.magnifyLevel), max(1.0, scale * delta))
                        }
                        .onEnded { _ in lastScale = 1.0 }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { val in
                            guard scale > 1.05 else { return }
                            offset = CGSize(
                                width:  lastOffset.width  + val.translation.width,
                                height: lastOffset.height + val.translation.height
                            )
                        }
                        .onEnded { _ in lastOffset = offset }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.spring(response: 0.35)) {
                        scale      = 1.0
                        offset     = .zero
                        lastOffset = .zero
                    }
                }
                .overlay(
                    Group {
                        if scale > 1.05 {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(String(format: "%.1f", scale))×")
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.black.opacity(0.55))
                                        .cornerRadius(8)
                                        .padding(10)
                                }
                                Spacer()
                            }
                        }
                    }
                )
        } else {
            content
        }
    }
}

// MARK: - SpeakButton
struct SpeakButton: View {
    let text: String
    @EnvironmentObject var a11y: AccessibilityManager
    @State private var speaking = false

    var body: some View {
        if a11y.readAloudEnabled {
            Button {
                if speaking {
                    a11y.stopSpeaking()
                    speaking = false
                } else {
                    speaking = true
                    a11y.speak(text)
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + max(2, Double(text.count) * 0.06)
                    ) { speaking = false }
                }
            } label: {
                Image(systemName: speaking ? "stop.circle.fill" : "speaker.wave.2.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(speaking ? .red : Color.cfGold)
            }
            .accessibilityLabel(speaking ? "Stop reading" : "Read aloud")
        }
    }
}
