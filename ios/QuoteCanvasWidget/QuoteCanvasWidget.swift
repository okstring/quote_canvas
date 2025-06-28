import WidgetKit
import SwiftUI

struct QuoteWidgetProvider: TimelineProvider {
    private let appGroupId = "group.com.okstring.quotecanvas"
    
    func placeholder(in context: Context) -> QuoteWidgetEntry {
        return QuoteWidgetEntry.placeholder
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QuoteWidgetEntry) -> Void) {
        let entry = createEntryForDate(Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteWidgetEntry>) -> Void) {
        var entries: [QuoteWidgetEntry] = []
        let currentDate = Date()
        
        // 다음 6시간 동안 매시간 새로운 엔트리 생성 (배터리 최적화)
        for hourOffset in 0..<6 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = createEntryForDate(entryDate)
            entries.append(entry)
        }
        
        // 6시간 후 다시 업데이트 되도록 설정
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
    
    private func createEntryForDate(_ date: Date) -> QuoteWidgetEntry {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            return createErrorEntry(date: date, message: "App Group access failed")
        }
        
        let lastUpdate = userDefaults.string(forKey: "last_update") ?? ""
        
        guard let quotesJsonString = userDefaults.string(forKey: "favorite_quotes"),
              !quotesJsonString.isEmpty,
              let quotesData = quotesJsonString.data(using: .utf8) else {
            let message = userDefaults.string(forKey: "no_favorites_message") ?? "No favorite quotes yet"
            return QuoteWidgetEntry(
                date: date,
                quote: nil,
                hasNoFavorites: true,
                noFavoritesMessage: message,
                lastUpdateDate: lastUpdate
            )
        }
        
        do {
            let quotes = try JSONDecoder().decode([QuoteData].self, from: quotesData)
            let validQuotes = quotes.filter { $0.isValid }
            
            guard !validQuotes.isEmpty else {
                return createErrorEntry(date: date, message: "No valid quotes found")
            }
            
            // 시간 기반 시드로 랜덤 선택 (같은 시간에는 같은 명언)
            let hour = Calendar.current.component(.hour, from: date)
            let day = Calendar.current.component(.day, from: date)
            let month = Calendar.current.component(.month, from: date)
            let seed = (hour + day * 24 + month * 24 * 31) % validQuotes.count
            
            let selectedQuote = validQuotes[seed]
            
            return QuoteWidgetEntry(
                date: date,
                quote: selectedQuote,
                hasNoFavorites: false,
                noFavoritesMessage: "",
                lastUpdateDate: lastUpdate
            )
            
        } catch {
            return createErrorEntry(date: date, message: "Failed to parse quotes")
        }
    }
    
    private func createErrorEntry(date: Date, message: String) -> QuoteWidgetEntry {
        return QuoteWidgetEntry(
            date: date,
            quote: nil,
            hasNoFavorites: true,
            noFavoritesMessage: message,
            lastUpdateDate: ""
        )
    }
}

struct QuoteWidgetView: View {
    var entry: QuoteWidgetEntry
    
    var body: some View {
        ZStack {
            // 배경색 설정 (기존 앱과 일치하는 색상)
            Color(.systemBackground)
            
            if entry.hasNoFavorites {
                NoFavoritesView(message: entry.noFavoritesMessage)
            } else if let quote = entry.quote {
                QuoteCardView(quote: quote)
            } else {
                PlaceholderView()
            }
        }
        .containerBackground(.background, for: .widget)
    }
}

struct QuoteCanvasWidget: Widget {
    let kind: String = "QuoteCanvasWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteWidgetProvider()) { entry in
            QuoteWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Quote Canvas")
        .description("Hourly inspiration from your favorite quotes")
        .supportedFamilies([.systemMedium])
        .contentMarginsDisabled()
    }
}
