import Foundation


class FeedParser: BaseParser {

    enum FeedType {
        case unknown
        case RSS
        case Atom
    }

    var type: FeedType = .unknown

    var items: [ParsedItem] = []
    var nextItem: ParsedItem?

    var isParsingHeader = true
    var source: ParsedSource? = ParsedSource()

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        switch elementName {
        case "rss":
            type = .RSS
        case "feed":
            type = .Atom
        case "channel":
            break;
        case "item", "entry":
            isParsingHeader = false
            nextItem = ParsedItem()
            textBuffer = ""
        case "author":
            if isParsingHeader {
                break
            }

            if type == .Atom {
                nextItem?.author = ParsedAuthor()
            }

        default:
            break;
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        switch elementName {
        case "title":
            if isParsingHeader {
                source?.title = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines);
            } else {
                nextItem?.title = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        case "link":
            if type == .Atom {
                break
            }

            if isParsingHeader {
                source?.link = URL(string: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))!
            } else {
                nextItem?.link = URL(string: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))!
            }
        case "dc:creator":
            nextItem?.author = ParsedAuthor(name: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))
        case "author":
            if isParsingHeader {
                break
            }

            if type == .RSS {
                nextItem?.author = ParsedAuthor(name: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))
            } else if type == .Atom {
                nextItem?.author = ParsedAuthor()
            }
        case "name":
            if isParsingHeader {
                break
            }

            if type == .RSS {
                nextItem?.author?.name = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        case "published":
            nextItem?.publishedAt = ISO8601DateFormatter().date(from: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date()
        case "pubDate":
            nextItem?.publishedAt = RFC822DateFormatter().date(from: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date()
        case "updated":
            nextItem?.updatedAt = ISO8601DateFormatter().date(from: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date()
        case "atom:updated":
            nextItem?.updatedAt = RFC822DateFormatter().date(from: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date()
        case "category":
            nextItem?.categories.append(textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))
        case "guid", "id":
            nextItem?.guid = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        case "description", "summary":
            if isParsingHeader {
                source?.desc = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines);
            } else {
                nextItem?.desc = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        case "item", "entry":
            if let item = nextItem {
                items.append(item)
            }
            nextItem = nil
        default:
            break;
        }

        textBuffer = ""
    }
}
