

import SwiftUI

struct SnakeGameView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = SnakeViewModel(cols: 20, rows: 28)

    var body: some View {
        ZStack {
            Color.cfGameBG.ignoresSafeArea()

            VStack(spacing: 0) {
                // ── HUD
                SnakeHUDView(vm: vm, dismiss: { dismiss() })
                    .padding(.top, 8)
                    .padding(.horizontal, 16)

                Spacer(minLength: 8)

                // ── Board
                GeometryReader { geo in
                    let cellW = geo.size.width  / CGFloat(vm.cols)
                    let cellH = geo.size.height / CGFloat(vm.rows)
                    let cellSize = min(cellW, cellH)

                    ZStack {
                        // Grid lines (subtle)
                        Canvas { ctx, size in
                            let lineColor = (Color.white as Color).opacity(0.04)
                            for c in 0...vm.cols {
                                let x = CGFloat(c) * cellSize
                                var p = Path(); p.move(to: CGPoint(x: x, y: 0))
                                p.addLine(to: CGPoint(x: x, y: size.height))
                                ctx.stroke(p, with: .color(lineColor), lineWidth: 0.5)
                            }
                            for r in 0...vm.rows {
                                let y = CGFloat(r) * cellSize
                                var p = Path(); p.move(to: CGPoint(x: 0, y: y))
                                p.addLine(to: CGPoint(x: size.width, y: y))
                                ctx.stroke(p, with: .color(lineColor), lineWidth: 0.5)
                            }
                        }

                        // Items
                        ForEach(vm.items) { item in
                            Text(item.emoji)
                                .font(.system(size: cellSize * 0.75))
                                .frame(width: cellSize, height: cellSize)
                                .position(
                                    x: CGFloat(item.cell.col) * cellSize + cellSize / 2,
                                    y: CGFloat(item.cell.row) * cellSize + cellSize / 2
                                )
                        }

                        // Snake body segments
                        ForEach(Array(vm.snakeBody.enumerated()), id: \.offset) { idx, cell in
                            if idx == 0 {
                                // Head → stickman
                                MiniStickman(
                                    size: cellSize * 1.3,
                                    color: appState.avatarBodyColor
                                )
                                .rotationEffect(headRotation)
                                .frame(width: cellSize, height: cellSize)
                                .position(
                                    x: CGFloat(cell.col) * cellSize + cellSize / 2,
                                    y: CGFloat(cell.row) * cellSize + cellSize / 2
                                )
                            } else {
                                // Body segment
                                RoundedRectangle(cornerRadius: cellSize * 0.35)
                                    .fill(
                                        LinearGradient(
                                            colors: [appState.avatarBodyColor, appState.avatarBodyColor.opacity(0.7)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: cellSize * 0.78, height: cellSize * 0.78)
                                    .position(
                                        x: CGFloat(cell.col) * cellSize + cellSize / 2,
                                        y: CGFloat(cell.row) * cellSize + cellSize / 2
                                    )
                                    .opacity(1.0 - Double(idx) * 0.015)
                            }
                        }

                        // Flash message
                        if let msg = vm.flashMessage {
                            Text(msg)
                                .font(.system(size: 22, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background((Color.black as Color).opacity(0.6))
                                .cornerRadius(12)
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(), value: vm.flashMessage)
                        }
                    }
                    .frame(
                        width: cellSize * CGFloat(vm.cols),
                        height: cellSize * CGFloat(vm.rows)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 4)

                Spacer(minLength: 8)

                // ── Swipe hint bar
                SwipeHintBar()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }

            // ── Swipe gesture (board area only — does NOT block HUD buttons)
            VStack(spacing: 0) {
                // Spacer to skip the HUD height (~60pt)
                Color.clear.frame(height: 60)
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 20)
                            .onEnded { value in
                                let h = value.translation.width
                                let v = value.translation.height
                                if abs(h) > abs(v) {
                                    vm.swipe(h > 0 ? .right : .left)
                                } else {
                                    vm.swipe(v > 0 ? .down : .up)
                                }
                            }
                    )
                // Spacer to skip swipe hint bar (~50pt)
                Color.clear.frame(height: 50)
            }

            // ── Game Over overlay
            if vm.isGameOver {
                SnakeGameOverlay(vm: vm, appState: appState, dismiss: { dismiss() })
            }

            // ── Paused overlay
            if vm.isPaused && !vm.isGameOver {
                (Color.black as Color).opacity(0.5).ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("⏸  Paused")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Button("Resume") { vm.togglePause() }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.cfGameBG)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.cfGreen)
                        .cornerRadius(14)
                }
            }
        }
    }

    private var headRotation: Angle {
        switch vm.direction {
        case .up:    return .degrees(-90)
        case .down:  return .degrees(90)
        case .left:  return .degrees(180)
        case .right: return .degrees(0)
        }
    }
}

// MARK: - HUD
struct SnakeHUDView: View {
    @ObservedObject var vm: SnakeViewModel
    let dismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Close
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }

            Spacer()

            // Score
            VStack(spacing: 1) {
                Text("SCORE")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.85))
                Text("\(vm.score)")
                    .font(.system(size: 22, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
            }

            Spacer()

            // Money earned
            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.cfGold)
                Text("\(vm.sessionMoney)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundColor(.cfGold)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background((Color.cfGold as Color).opacity(0.15))
            .cornerRadius(10)

            // Pause
            Button { vm.togglePause() } label: {
                Image(systemName: vm.isPaused ? "play.circle.fill" : "pause.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Swipe hint
struct SwipeHintBar: View {
    var body: some View {
        HStack(spacing: 20) {
            ForEach(["arrow.up", "arrow.left", "arrow.down", "arrow.right"], id: \.self) { icon in
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
            }
            Text("SWIPE TO MOVE")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.white.opacity(0.25))
                .kerning(1.5)
        }
    }
}

// MARK: - Game Over Overlay
struct SnakeGameOverlay: View {
    @ObservedObject var vm: SnakeViewModel
    @ObservedObject var appState: AppState
    let dismiss: () -> Void

    @State private var saved = false

    var body: some View {
        ZStack {
            (Color.black as Color).opacity(0.75).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🐍  Game Over")
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.white)

                VStack(spacing: 8) {
                    StatRow(label: "Score",        value: "\(vm.score)",        color: .white)
                    StatRow(label: "Coins Earned", value: "+$\(max(0, vm.sessionMoney))", color: .cfGold)
                    StatRow(label: "Snake Length", value: "\(vm.snakeBody.count)", color: .cfGreen)
                }
                .padding(20)
                .background((Color.white as Color).opacity(0.08))
                .cornerRadius(16)

                if !saved {
                    Button {
                        save()
                    } label: {
                        Label("Save & Continue", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.cfGameBG)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.cfGreen)
                            .cornerRadius(14)
                    }
                }

                Button("Play Again") {
                    vm.resetGame()
                }
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.7))

                Button("Exit") { dismiss() }
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(28)
            .frame(maxWidth: 320)
        }
        .transition(.opacity)
    }

    private func save() {
        if vm.score > appState.snakeHighScore {
            appState.snakeHighScore = vm.score
        }
        if vm.sessionMoney > 0 {
            appState.addMoney(vm.sessionMoney)
        }
        appState.totalTrashCollected += vm.items.filter { $0.type == .trash || $0.type == .recycle }.count
        saved = true
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
        }
    }
}
