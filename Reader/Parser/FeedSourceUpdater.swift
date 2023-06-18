import Foundation
import CoreData

class FeedSourceUpdater: NSObject {

    private func update(feedItem: FeedItem, with item: ParsedItem) {
        feedItem.title = item.title
        feedItem.link = item.link
        feedItem.author = item.author?.name ?? ""
        feedItem.publishedAt = item.publishedAt
        feedItem.updatedAt = item.updatedAt
        feedItem.guid = item.guid
        feedItem.desc = item.desc
    }

    private func update(feedSource: FeedSource, with source: ParsedSource) {
        feedSource.title = source.title
        feedSource.link = source.link
        feedSource.desc = source.desc
        feedSource.fetchedAt = Date()
        feedSource.updatedAt = Date()
    }

    func update(source: FeedSource, context: NSManagedObjectContext) async {

        print("Fetching url: \(source.url)");
        do {
            let (data, _) = try await URLSession.shared.data(from: source.url)

            // Determine RSS or ATOM

            let parser = FeedParser (data: data);
            parser.parse()

            if let parsedSource = parser.source {
                update(feedSource: source, with: parsedSource)
            }

            if let sourceItems = source.items {
                source.removeFromItems(sourceItems)
            }

            for item in parser.items {
                let newItem = FeedItem(context: context)
                update(feedItem: newItem, with: item)
                source.addToItems(newItem)
            }

        } catch {
            let nsError = error as NSError
            fatalError("Unresolved fetching error \(nsError), \(nsError.userInfo)")
        }
    }
}
