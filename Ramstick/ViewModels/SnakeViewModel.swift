// SnakeViewModel.swift

import SwiftUI
import Combine

// MARK: - Types
enum Direction { case up, down, left, right }

enum CellItem: Equatable {
    case trash      // eat → grow +1, +$5
    case recycle    // eat → grow +1, +$8
    case toxic      // eat → shrink -1, -$10
    case litter     // eat → shrink -1, -$7
}

struct GridCell: Hashable {
    var col: Int
    var row: Int
}

struct PickupItem: Identifiable {
    let id = UUID()
    let cell: GridCell
    let type: CellItem
    var emoji: String {
        switch type {
        case .trash:   return "🗑️"
        case .recycle: return "♻️"
        case .toxic:   return "☢️"
        case .litter:  return "🚯"
        }
    }
    var moneyDelta: Int {
        switch type {
        case .trash:   return  5
        case .recycle: return  8
        case .toxic:   return -10
        case .litter:  return  -7
        }
    }
    var growDelta: Int {
        switch type {
        case .trash, .recycle: return  1
        case .toxic, .litter:  return -1
        }
    }
}

// MARK: - ViewModel
class SnakeViewModel: ObservableObject {
    let cols: Int
    let rows: Int

    @Published var snakeBody: [GridCell] = []
    @Published var items:     [PickupItem] = []
    @Published var direction: Direction = .right
    @Published var score:     Int = 0
    @Published var sessionMoney: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isPaused:   Bool = false
    @Published var flashMessage: String? = nil

    private var pendingDirection: Direction = .right
    private var timer: AnyCancellable?
    private var pendingGrowth: Int = 0

    init(cols: Int = 20, rows: Int = 30) {
        self.cols = cols
        self.rows = rows
        resetGame()
    }

    // MARK: - Game Lifecycle
    func resetGame() {
        let startCol = cols / 2
        let startRow = rows / 2
        snakeBody     = [
            GridCell(col: startCol,     row: startRow),
            GridCell(col: startCol - 1, row: startRow),
            GridCell(col: startCol - 2, row: startRow)
        ]
        direction        = .right
        pendingDirection = .right
        score            = 0
        sessionMoney     = 0
        isGameOver       = false
        isPaused         = false
        pendingGrowth    = 0
        items            = []
        spawnItems()
        startTimer()
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused { stopTimer() } else { startTimer() }
    }

    // MARK: - Input
    func swipe(_ dir: Direction) {
        // Prevent reversing
        let invalid: Direction
        switch direction {
        case .up:    invalid = .down
        case .down:  invalid = .up
        case .left:  invalid = .right
        case .right: invalid = .left
        }
        if dir != invalid { pendingDirection = dir }
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 0.18, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.step() }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    // MARK: - Core Step
    private func step() {
        guard !isGameOver, !isPaused else { return }
        direction = pendingDirection

        var head = snakeBody[0]
        switch direction {
        case .up:    head.row -= 1
        case .down:  head.row += 1
        case .left:  head.col -= 1
        case .right: head.col += 1
        }

        // ── Wall wrap-through (classic snake behaviour)
        head.col = ((head.col % cols) + cols) % cols
        head.row = ((head.row % rows) + rows) % rows

        // ── Self-collision → game over
        if snakeBody.contains(head) {
            endGame()
            return
        }

        // ── Move
        var newBody = [head] + snakeBody

        // Apply pending growth
        if pendingGrowth > 0 {
            pendingGrowth -= 1
            // Keep tail (natural growth)
        } else if pendingGrowth < 0 {
            // Shrink: remove extra from tail
            if newBody.count > 1 {
                newBody.removeLast()
                newBody.removeLast() // remove two: the moved one + one more
            }
            pendingGrowth += 1
            if newBody.count < 1 { endGame(); return }
        } else {
            newBody.removeLast()
        }

        snakeBody = newBody

        // ── Check pickups
        checkPickups(head: head)

        // ── Ensure items always present
        if items.count < 4 { spawnItems() }
    }

    // MARK: - Pickup collision
    private func checkPickups(head: GridCell) {
        for i in items.indices.reversed() {
            let item = items[i]
            if item.cell == head {
                items.remove(at: i)
                let delta = item.moneyDelta
                let grow  = item.growDelta

                sessionMoney += delta
                if delta > 0 { score += abs(delta) }

                pendingGrowth += grow

                // Flash message
                let msg = delta > 0 ? "+$\(delta) 🌿" : "\(delta)$ ☠️"
                showFlash(msg)

                // Prevent snake shrinking below 1
                if snakeBody.count + pendingGrowth < 1 {
                    pendingGrowth = -(snakeBody.count - 1)
                }

                spawnItem()
            }
        }
    }

    // MARK: - Spawning
    private func spawnItems() {
        for _ in 0..<4 { spawnItem() }
    }

    private func spawnItem() {
        var attempts = 0
        while attempts < 50 {
            let cell = GridCell(col: Int.random(in: 0..<cols), row: Int.random(in: 0..<rows))
            if !snakeBody.contains(cell) && !items.contains(where: { $0.cell == cell }) {
                let type = randomItemType()
                items.append(PickupItem(cell: cell, type: type))
                return
            }
            attempts += 1
        }
    }

    private func randomItemType() -> CellItem {
        // 60% good, 40% bad
        let r = Int.random(in: 0..<10)
        switch r {
        case 0...3: return .trash
        case 4...5: return .recycle
        case 6...7: return .toxic
        default:    return .litter
        }
    }

    // MARK: - Game Over
    private func endGame() {
        stopTimer()
        isGameOver = true
    }

    // MARK: - Flash
    private func showFlash(_ msg: String) {
        flashMessage = msg
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.flashMessage = nil
        }
    }
}
