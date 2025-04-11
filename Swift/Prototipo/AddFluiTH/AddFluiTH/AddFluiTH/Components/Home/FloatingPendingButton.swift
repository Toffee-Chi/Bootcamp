import SwiftUI

struct FloatingPendingButton: View {
    var body: some View {
        NavigationLink(value: "PendingView") {
            Image("ic_pending_actions")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
        }
        .frame(width: 150, height: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.3), radius: 8, x: 2, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 0.3)
        )
    }
}
