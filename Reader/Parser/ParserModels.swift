import Foundation

struct ParsedAuthor {
    var name: String? = nil
}

struct ParsedItem {
    var title: String = ""
    var link: URL? = nil
    var author: ParsedAuthor? = nil
    var publishedAt: Date = Date()
    var updatedAt: Date = Date()
    var categories: [String] = []
    var guid: String = ""
    var desc: String = ""
}

struct ParsedSource {
    var title: String = ""
    var desc: String = ""
    var link: URL? = nil
}
