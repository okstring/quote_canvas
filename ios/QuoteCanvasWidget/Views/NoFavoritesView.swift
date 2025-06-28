import SwiftUI

struct NoFavoritesView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.slash")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            
            Text("Open Quote Canvas to add favorites")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
