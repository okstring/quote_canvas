import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "quote.bubble")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("Loading quotes...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
