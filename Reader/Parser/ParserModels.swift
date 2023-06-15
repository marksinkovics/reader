import Foundation

struct ParsedAuthor {
    var name: String? = nil
}

struct ParsedItem {
    var title: String? = nil
    var link: URL? = nil
    var author: ParsedAuthor? = nil
    var publishedAt: Date? = nil
    var updatedAt: Date? = nil
    var categories: [String] = []
    var guid: String? = nil
    var desc: String = ""
}

struct ParsedSource {
    var title: String?
    var desc: String?
    var link: URL?
}
