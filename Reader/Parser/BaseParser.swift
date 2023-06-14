import Foundation

class BaseParser: NSObject, XMLParserDelegate {
    let parser: XMLParser
    var textBuffer: String = ""

    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        parser.delegate = self
    }

    func parse() {
        parser.parse()
    }

    func parserDidStartDocument(_ parser: XMLParser) {
//        print("Start of the document")
//        print("Line number: \(parser.lineNumber)")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
//        print("End of the document")
//        print("Line number: \(parser.lineNumber)")
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        print("start element: \(elementName)")
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("end element: \(elementName)")
    }

    // Called when a character sequence is found
    // This may be called multiple times in a single element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }

    // Called when a CDATA block is found
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            print("CDATA contains non-textual data, ignored")
            return
        }
        textBuffer += string
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        print("on:", parser.lineNumber, "at:", parser.columnNumber)
    }
}

