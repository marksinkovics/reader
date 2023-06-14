import Foundation

class FeedSourceRSSParser: BaseParser {

    var isParsingChannel = true
    var source: ParsedSource? = nil
    var nextSource: ParsedSource? = nil

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        switch elementName {
        case "channel":
            source = ParsedSource()
        case "item":
            isParsingChannel = false
        default:
            break;
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        switch elementName {
        case "title":
            if isParsingChannel {
                source?.title = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines);
            }
        case "description":
            if isParsingChannel {
                source?.desc = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines);
            }
        case "link":
            if isParsingChannel {
                source?.link = URL(string: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))!
            }
        default:
            break;
        }

        textBuffer = ""

    }
}

class FeedSourceItemsRSSParser: BaseParser {
    lazy var dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()

    var items: [ParsedItem] = []
    var nextItem: ParsedItem?

    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
        switch elementName {
        case "item":
            nextItem = ParsedItem()
            textBuffer = ""
        default:
            break;
        }
    }

    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
        switch elementName {
        case "title":
            nextItem?.title = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        case "link":
            nextItem?.link = URL(string: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))!
        case "dc:creator":
            nextItem?.author = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        case "author":
            nextItem?.author = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        case "pubDate":
            nextItem?.publishedAt = dateFormatter.date(from: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))
        case "atom:updated":
            nextItem?.updatedAt = dateFormatter.date(from: textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))
        case "category":
            nextItem?.categories.append(textBuffer.trimmingCharacters(in: .whitespacesAndNewlines))
        case "guid":
            nextItem?.guid = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        case "description":
            nextItem?.desc = textBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        case "item":
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
