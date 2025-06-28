import Foundation

struct QuoteData: Codable {
    let id: String?
    let q: String? // content - API JSON 구조와 일치
    let a: String? // author - API JSON 구조와 일치
    let language: String?
    
    var content: String { 
        return q?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "No quote available" 
    }
    var author: String { 
        return a?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Unknown" 
    }
    
    // 빈 데이터 검증
    var isValid: Bool {
        return !(content.isEmpty || content == "No quote available")
    }
}
