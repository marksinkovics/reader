import Foundation

struct ParsedItem {
    var title: String? = nil
    var link: URL? = nil
    var author: String? = nil
    var publishedAt: Date? = nil
    var updatedAt: Date? = nil
    var categories: [String] = []
    var guid: String? = nil
    var desc: String? = nil
}

struct ParsedSource {
    var title: String?
    var desc: String?
    var link: URL?
}
