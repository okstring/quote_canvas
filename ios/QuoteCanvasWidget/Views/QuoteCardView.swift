import SwiftUI

struct QuoteCardView: View {
    let quote: QuoteData
    
    var body: some View {
        VStack(spacing: 8) {
            // 헤더
            HStack {
                Text("Quote Canvas")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "quote.bubble.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer(minLength: 4)
            
            // 명언 내용
            Text(quote.content)
                .font(.system(size: 13, weight: .medium, design: .default))
                .multilineTextAlignment(.center)
                .lineLimit(5)
                .minimumScaleFactor(0.6)
                .foregroundColor(.primary)
                .padding(.horizontal, 4)
            
            Spacer(minLength: 4)
            
            // 작가
            HStack {
                Spacer()
                Text("- \(quote.author)")
                    .font(.caption2)
                    .italic()
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .padding(12)
    }
}
