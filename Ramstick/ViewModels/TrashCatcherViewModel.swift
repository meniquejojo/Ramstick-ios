// TrashCatcherViewModel.swift
import SwiftUI
import Combine

enum FallingItemKind: CaseIterable {
    case recyclable, trash, food, hazardous, litter

    var emoji: String {
        switch self {
        case .recyclable: return "♻️"
        case .trash:      return "🗑️"
        case .food:       return "🍎"
        case .hazardous:  return "☢️"
        case .litter:     return "🚬"
        }
    }
    var coins: Int {
        switch self {
        case .recyclable: return  8
        case .trash:      return  5
        case .food:       return  4
        case .hazardous:  return -12
        case .litter:     return -8
        }
    }
    var isHarmful: Bool { coins < 0 }
    var coinLabel: String {
        coins > 0 ? "+$\(coins)" : "-$\(abs(coins)) ☠️"
    }
    var color: Color {
        switch self {
        case .recyclable: return Color.cfGreen
        case .trash:      return Color.gray
        case .food:       return Color.orange
        case .hazardous:  return Color.red
        case .litter:     return Color.purple
        }
    }
}

struct FallingObject: Identifiable {
    let id    = UUID()
    let kind  : FallingItemKind
    var xNorm : CGFloat      // 0…1
    var yNorm : CGFloat      // 0=top, 1=bottom
    let speed : CGFloat      // normalized units per frame
}

struct FloatEffect: Identifiable {
    let id    = UUID()
    let text  : String
    let color : Color
    var xNorm : CGFloat
    var yNorm : CGFloat
    var alpha : Double = 1.0
}

class TrashCatcherViewModel: ObservableObject {

    @Published var objects: [FallingObject] = []
    @Published var effects: [FloatEffect]   = []
    @Published var binX:    CGFloat = 0.5
    @Published var score:   Int     = 0
    @Published var coins:   Int     = 0
    @Published var lives:   Int     = 3
    @Published var level:   Int     = 1
    @Published var streak:  Int     = 0
    @Published var isOver:  Bool    = false
    @Published var paused:  Bool    = false

    private var gameLoop:   AnyCancellable?
    private var spawner:    AnyCancellable?
    private var fader:      AnyCancellable?
    private var ticks:      Int = 0

    let binHalfW: CGFloat = 0.11   // half-width of bin in normalized coords
    private let catchY:  CGFloat  = 0.87

    // MARK: Start / Restart
    func start() {
        objects = []; effects = []
        score = 0; coins = 0; lives = 3
        level = 1; streak = 0; ticks = 0
        isOver = false; paused = false
        launchTimers()
    }

    func togglePause() {
        paused.toggle()
        if paused { killTimers() } else { launchTimers() }
    }

    func moveBin(normX: CGFloat) {
        binX = min(max(normX, binHalfW), 1 - binHalfW)
    }

    // MARK: Timers
    private func launchTimers() {
        killTimers()
        gameLoop = Timer.publish(every: 1/60.0, on: .main, in: .common)
            .autoconnect().sink { [weak self] _ in self?.tick() }
        spawner  = Timer.publish(every: spawnRate, on: .main, in: .common)
            .autoconnect().sink { [weak self] _ in self?.spawn() }
        fader    = Timer.publish(every: 0.04,  on: .main, in: .common)
            .autoconnect().sink { [weak self] _ in self?.fadeEffects() }
    }
    private func killTimers() {
        gameLoop?.cancel(); spawner?.cancel(); fader?.cancel()
    }

    private var spawnRate: Double { max(0.6 - Double(level) * 0.04, 0.22) }
    private var dropSpeed: CGFloat { 0.006 + CGFloat(level) * 0.0016 }

    // MARK: Tick
    private func tick() {
        guard !isOver, !paused else { return }
        ticks += 1
        if ticks % 960 == 0 { level = min(level + 1, 12) }

        var remove: [UUID] = []
        for i in objects.indices {
            objects[i].yNorm += dropSpeed + objects[i].speed
            if objects[i].yNorm >= catchY {
                let obj = objects[i]
                remove.append(obj.id)
                evaluate(obj)
            }
        }
        objects.removeAll { remove.contains($0.id) }
    }

    private func evaluate(_ obj: FallingObject) {
        let inBin = abs(obj.xNorm - binX) <= binHalfW
        if inBin {
            let c = obj.kind.coins
            coins  += c
            score  += max(c, 0)
            if c > 0 {
                streak += 1
                if streak > 0 && streak % 5 == 0 {
                    coins += 10
                    flash("+$10 🔥 Streak!", color: .orange, x: obj.xNorm, y: catchY - 0.06)
                } else {
                    flash(obj.kind.coinLabel, color: obj.kind.color, x: obj.xNorm, y: catchY - 0.05)
                }
            } else {
                streak = 0
                flash(obj.kind.coinLabel, color: .red, x: obj.xNorm, y: catchY - 0.05)
            }
        } else {
            // missed a good item — lose a life
            if !obj.kind.isHarmful {
                lives -= 1
                flash("Missed -❤️", color: .red, x: obj.xNorm, y: catchY - 0.04)
                if lives <= 0 { endGame() }
            }
        }
    }

    private func endGame() { killTimers(); isOver = true }

    // MARK: Spawn
    private func spawn() {
        guard !isOver, !paused else { return }
        let harmChance = min(0.12 + Double(level) * 0.025, 0.32)
        let kind: FallingItemKind
        if Double.random(in: 0...1) < harmChance {
            kind = Bool.random() ? .hazardous : .litter
        } else {
            kind = [.trash, .trash, .recyclable, .recyclable, .food].randomElement()!
        }
        objects.append(FallingObject(
            kind: kind,
            xNorm: CGFloat.random(in: 0.05...0.95),
            yNorm: 0,
            speed: CGFloat.random(in: -0.001...0.002)
        ))
        if objects.count > 14 { objects.removeFirst() }
    }

    // MARK: Effects
    private func flash(_ text: String, color: Color, x: CGFloat, y: CGFloat) {
        effects.append(FloatEffect(text: text, color: color, xNorm: x, yNorm: y))
    }
    private func fadeEffects() {
        for i in effects.indices.reversed() {
            effects[i].alpha  -= 0.045
            effects[i].yNorm  -= 0.007
        }
        effects.removeAll { $0.alpha <= 0 }
    }
}
