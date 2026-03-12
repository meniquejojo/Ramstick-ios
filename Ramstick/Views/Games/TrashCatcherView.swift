// TrashCatcherView.swift
import SwiftUI

struct TrashCatcherView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = TrashCatcherViewModel()
    @State private var earned = false

    var body: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H = geo.size.height

            ZStack(alignment: .top) {
                // ── Sky gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.06, green: 0.11, blue: 0.06),
                        Color(red: 0.03, green: 0.06, blue: 0.03)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                // ── Ground strip
                VStack {
                    Spacer()
                    Rectangle()
                        .fill((Color.white as Color).opacity(0.05))
                        .frame(height: 2)
                        .offset(y: -(H * 0.13))
                }

                // ── Falling objects
                ForEach(vm.objects) { obj in
                    Text(obj.kind.emoji)
                        .font(Font.system(size: 34))
                        .shadow(color: obj.kind.color.opacity(0.7), radius: 7)
                        .position(x: obj.xNorm * W, y: obj.yNorm * H)
                }

                // ── Float effects
                ForEach(vm.effects) { eff in
                    Text(eff.text)
                        .font(Font.system(size: 13, weight: .black))
                        .foregroundColor(eff.color)
                        .shadow(color: eff.color.opacity(0.9), radius: 4)
                        .position(x: eff.xNorm * W, y: eff.yNorm * H)
                        .opacity(eff.alpha)
                }

                // ── Trash bin
                TCBinView(halfW: vm.binHalfW * W)
                    .position(x: vm.binX * W, y: H * 0.91)

                // ── HUD
                TCHudView(vm: vm) { dismiss() }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                // ── Level badge
                VStack {
                    Spacer()
                    Text("LEVEL  \(vm.level)")
                        .font(Font.system(size: 10, weight: .black, design: .monospaced))
                        .foregroundColor((Color.white as Color).opacity(0.25))
                        .kerning(3)
                        .padding(.bottom, 6)
                }
            }
            // ── Trash bin drag (bottom 80% of screen only, so HUD stays tappable)
            GeometryReader { dragGeo in
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { v in vm.moveBin(normX: v.location.x / dragGeo.size.width) }
                    )
                    .padding(.top, 80) // skip HUD area at top
            }
        }
        .ignoresSafeArea()
        // Pause overlay
        .overlay {
            if vm.paused && !vm.isOver {
                Color.black.opacity(0.55).ignoresSafeArea()
                VStack(spacing: 18) {
                    Text("⏸  Paused")
                        .font(Font.system(size: 28, weight: .bold))
                        .foregroundColor(Color.white)
                    Button("Resume") { vm.togglePause() }
                        .font(Font.system(size: 17, weight: .semibold))
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 13)
                        .background(Color.cfGreen)
                        .cornerRadius(14)
                }
            }
        }
        // Game over overlay
        .overlay {
            if vm.isOver {
                TCGameOverView(vm: vm, appState: appState, earned: $earned) { dismiss() }
            }
        }
        .onAppear { vm.start() }
    }
}

// MARK: - Trash Bin
struct TCBinView: View {
    let halfW: CGFloat
    private var w: CGFloat { halfW * 2 }
    private var h: CGFloat { w * 0.56 }

    var body: some View {
        ZStack {
            // Body
            RoundedRectangle(cornerRadius: 7)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.22, green: 0.58, blue: 0.27),
                            Color(red: 0.14, green: 0.40, blue: 0.18)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .frame(width: w, height: h)
                .shadow(color: Color.cfGreen.opacity(0.55), radius: 10, y: 4)

            // Lid
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(red: 0.28, green: 0.68, blue: 0.33))
                .frame(width: w * 1.12, height: h * 0.17)
                .offset(y: -(h / 2) - (h * 0.085))

            // ♻️ icon
            Text("♻️")
                .font(Font.system(size: w * 0.32))
        }
    }
}

// MARK: - HUD
struct TCHudView: View {
    @ObservedObject var vm: TrashCatcherViewModel
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(Font.system(size: 28))
                    .foregroundColor(Color.white)
            }

            Spacer()

            // Lives
            HStack(spacing: 2) {
                ForEach(0..<3, id: \.self) { i in
                    Text(i < vm.lives ? "❤️" : "🖤")
                        .font(Font.system(size: 15))
                }
            }

            Spacer()

            // Score
            VStack(spacing: 0) {
                Text("SCORE")
                    .font(Font.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor((Color.white as Color).opacity(0.85))
                    .kerning(1.5)
                Text("\(vm.score)")
                    .font(Font.system(size: 20, weight: .black, design: .monospaced))
                    .foregroundColor(Color.white)
            }

            Spacer()

            // Coins
            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(Color.cfGold)
                    .font(Font.system(size: 14))
                Text("\(vm.coins)")
                    .font(Font.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundColor(Color.cfGold)
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background((Color.cfGold as Color).opacity(0.14))
            .cornerRadius(10)

            Spacer()

            Button { vm.togglePause() } label: {
                Image(systemName: vm.paused ? "play.circle.fill" : "pause.circle.fill")
                    .font(Font.system(size: 28))
                    .foregroundColor(Color.white)
            }
        }
    }
}

// MARK: - Game Over
struct TCGameOverView: View {
    @ObservedObject var vm: TrashCatcherViewModel
    @ObservedObject var appState: AppState
    @Binding var earned: Bool
    let onExit: () -> Void

    var body: some View {
        ZStack {
            (Color.black as Color).opacity(0.78).ignoresSafeArea()
            VStack(spacing: 20) {

                Text(vm.score > 100 ? "🌍 Planet Saved!"
                     : vm.score > 50 ? "♻️ Good Effort!"
                     : "🗑️ Keep Trying!")
                    .font(Font.system(size: 28, weight: .black))
                    .foregroundColor(Color.white)

                VStack(spacing: 10) {
                    TCStatRow(label: "Score",         value: "\(vm.score)",        color: Color.white)
                    TCStatRow(label: "Coins Earned",  value: "+$\(max(0, vm.coins))", color: Color.cfGold)
                    TCStatRow(label: "Level Reached", value: "Level \(vm.level)",  color: Color.cfGreen)
                    TCStatRow(label: "Best Streak",   value: "\(vm.streak) catches", color: Color.orange)
                }
                .padding(18)
                .background((Color.white as Color).opacity(0.07))
                .cornerRadius(16)

                if !earned {
                    Button {
                        if vm.coins > 0   { appState.addMoney(vm.coins) }
                        if vm.score > appState.snakeHighScore { appState.snakeHighScore = vm.score }
                        earned = true
                    } label: {
                        Label("Save Earnings", systemImage: "checkmark.circle.fill")
                            .font(Font.system(size: 17, weight: .bold))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.cfGreen)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 4)
                } else {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(Color.cfGreen)
                        Text("Saved to wallet!").font(Font.system(size: 15, weight: .semibold)).foregroundColor(Color.cfGreen)
                    }
                }

                Button("Play Again") { vm.start(); earned = false }
                    .font(Font.system(size: 15, weight: .semibold))
                    .foregroundColor((Color.white as Color).opacity(0.7))

                Button("Exit", action: onExit)
                    .font(Font.system(size: 13))
                    .foregroundColor((Color.white as Color).opacity(0.4))
            }
            .padding(28)
            .frame(maxWidth: 320)
        }
    }
}

struct TCStatRow: View {
    let label: String
    let value: String
    let color: Color
    var body: some View {
        HStack {
            Text(label).font(Font.system(size: 14)).foregroundColor((Color.white as Color).opacity(0.6))
            Spacer()
            Text(value).font(Font.system(size: 15, weight: .bold)).foregroundColor(color)
        }
    }
}
