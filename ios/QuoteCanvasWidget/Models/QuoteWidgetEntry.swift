import WidgetKit
import Foundation

struct QuoteWidgetEntry: TimelineEntry {
    let date: Date
    let quote: QuoteData?
    let hasNoFavorites: Bool
    let noFavoritesMessage: String
    let lastUpdateDate: String
    
    static let placeholder = QuoteWidgetEntry(
        date: Date(),
        quote: QuoteData(
            id: "sample", 
            q: "Every moment is a fresh beginning.", 
            a: "T.S. Eliot", 
            language: "en"
        ),
        hasNoFavorites: false,
        noFavoritesMessage: "",
        lastUpdateDate: ""
    )
}
