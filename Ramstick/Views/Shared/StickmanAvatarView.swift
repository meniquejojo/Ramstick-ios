// StickmanAvatarView.swift
// Reusable customizable stickman drawn with SwiftUI Canvas

import SwiftUI

struct StickmanAvatarView: View {
    var size: CGFloat = 60
    var bodyColor: Color = .cfMaroon
    var accessory: AvatarAccessory = .none
    var animated: Bool = false

    @State private var bounce: CGFloat = 0

    var body: some View {
        Canvas { ctx, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w / 2
            let unit = h / 10

            

            // ── Head
            let headRadius = unit * 1.4
            let headCenter = CGPoint(x: cx, y: unit * 1.8 + bounce)
            ctx.fill(
                Path(ellipseIn: CGRect(
                    x: headCenter.x - headRadius,
                    y: headCenter.y - headRadius,
                    width: headRadius * 2,
                    height: headRadius * 2
                )),
                with: .color(bodyColor)
            )

            // ── Face – eyes
            let eyeY = headCenter.y - unit * 0.3
            let eyeR: CGFloat = unit * 0.22
            ctx.fill(
                Path(ellipseIn: CGRect(x: headCenter.x - unit * 0.55 - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2)),
                with: .color(.white)
            )
            ctx.fill(
                Path(ellipseIn: CGRect(x: headCenter.x + unit * 0.55 - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2)),
                with: .color(.white)
            )

            // ── Smile
            var smile = Path()
            smile.addArc(center: CGPoint(x: headCenter.x, y: headCenter.y + unit * 0.1),
                         radius: unit * 0.55, startAngle: .degrees(20), endAngle: .degrees(160), clockwise: false)
            ctx.stroke(smile, with: .color(.white), lineWidth: unit * 0.18)

            // ── Neck & torso
            let neckTop    = CGPoint(x: cx, y: headCenter.y + headRadius)
            let shoulderY  = neckTop.y + unit * 0.6 + bounce * 0.4
            let hipY       = shoulderY + unit * 2.2

            var torso = Path()
            torso.move(to: neckTop)
            torso.addLine(to: CGPoint(x: cx, y: hipY))
            ctx.stroke(torso, with: .color(bodyColor), style: StrokeStyle(lineWidth: unit * 0.35, lineCap: .round))

            // ── Arms
            var leftArm = Path()
            leftArm.move(to: CGPoint(x: cx, y: shoulderY))
            leftArm.addLine(to: CGPoint(x: cx - unit * 1.4, y: shoulderY + unit * 1.3 + bounce * 0.5))
            ctx.stroke(leftArm, with: .color(bodyColor), style: StrokeStyle(lineWidth: unit * 0.28, lineCap: .round))

            var rightArm = Path()
            rightArm.move(to: CGPoint(x: cx, y: shoulderY))
            rightArm.addLine(to: CGPoint(x: cx + unit * 1.4, y: shoulderY + unit * 1.3 - bounce * 0.5))
            ctx.stroke(rightArm, with: .color(bodyColor), style: StrokeStyle(lineWidth: unit * 0.28, lineCap: .round))

            // ── Legs
            var leftLeg = Path()
            leftLeg.move(to: CGPoint(x: cx, y: hipY))
            leftLeg.addLine(to: CGPoint(x: cx - unit * 1.1, y: hipY + unit * 2.0 - bounce * 0.6))
            ctx.stroke(leftLeg, with: .color(bodyColor), style: StrokeStyle(lineWidth: unit * 0.28, lineCap: .round))

            var rightLeg = Path()
            rightLeg.move(to: CGPoint(x: cx, y: hipY))
            rightLeg.addLine(to: CGPoint(x: cx + unit * 1.1, y: hipY + unit * 2.0 + bounce * 0.6))
            ctx.stroke(rightLeg, with: .color(bodyColor), style: StrokeStyle(lineWidth: unit * 0.28, lineCap: .round))

            // ── Accessory overlay text
        }
        .frame(width: size, height: size)
        .overlay(alignment: .top) {
            if accessory != .none {
                Text(accessoryEmoji)
                    .font(.system(size: size * 0.28))
                    .offset(y: -size * 0.04)
            }
        }
        .onAppear {
            guard animated else { return }
            withAnimation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true)) {
                bounce = 3
            }
        }
    }

    private var accessoryEmoji: String {
        switch accessory {
        case .none:     return ""
        case .cap:      return "🎓"
        case .headband: return "🎽"
        case .crown:    return "👑"
        case .halo:     return "✨"
        }
    }
}

// MARK: - Mini Stickman (for snake head)
struct MiniStickman: View {
    var size: CGFloat = 20
    var color: Color = .cfGreen

    var body: some View {
        Canvas { ctx, cs in
            let w = cs.width, h = cs.height
            let cx = w / 2
            let u = h / 10

            ctx.fill(Path(ellipseIn: CGRect(x: cx - u * 1.2, y: 0, width: u * 2.4, height: u * 2.4)), with: .color(color))

            var body = Path()
            body.move(to: CGPoint(x: cx, y: u * 2.4))
            body.addLine(to: CGPoint(x: cx, y: u * 6))
            ctx.stroke(body, with: .color(color), lineWidth: u * 0.4)

            var la = Path(); la.move(to: CGPoint(x: cx, y: u * 3.5))
            la.addLine(to: CGPoint(x: cx - u * 1.5, y: u * 5))
            ctx.stroke(la, with: .color(color), lineWidth: u * 0.3)

            var ra = Path(); ra.move(to: CGPoint(x: cx, y: u * 3.5))
            ra.addLine(to: CGPoint(x: cx + u * 1.5, y: u * 5))
            ctx.stroke(ra, with: .color(color), lineWidth: u * 0.3)

            var ll = Path(); ll.move(to: CGPoint(x: cx, y: u * 6))
            ll.addLine(to: CGPoint(x: cx - u * 1.2, y: u * 9.5))
            ctx.stroke(ll, with: .color(color), lineWidth: u * 0.3)

            var rl = Path(); rl.move(to: CGPoint(x: cx, y: u * 6))
            rl.addLine(to: CGPoint(x: cx + u * 1.2, y: u * 9.5))
            ctx.stroke(rl, with: .color(color), lineWidth: u * 0.3)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 20) {
        StickmanAvatarView(size: 80, bodyColor: .cfMaroon, accessory: .cap, animated: true)
        StickmanAvatarView(size: 80, bodyColor: .cfGreen, accessory: .crown, animated: true)
        MiniStickman(size: 40, color: .cfGreen)
    }
    .padding()
}
