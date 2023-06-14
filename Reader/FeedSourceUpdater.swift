import Foundation
import CoreData

class FeedSourceUpdater: NSObject {

    private func update(feedItem: FeedItem, with item: ParsedItem) {
        feedItem.title = item.title
        feedItem.link = item.link
        feedItem.author = item.author
        feedItem.publishedAt = item.publishedAt
        feedItem.updatedAt = item.updatedAt ?? Date()
//        feedItem.categories = item.categories
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

        guard let url = source.url else { return }

        print("Fetching url: \(url)");
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Determine RSS or ATOM

            let sourceParser = FeedSourceRSSParser(data: data);
            sourceParser.parse()

            if let parsedSource = sourceParser.source {
                update(feedSource: source, with: parsedSource)
            }

            let itemsParser = FeedSourceItemsRSSParser(data: data);
            itemsParser.parse()

            if let sourceItems = source.items {
                source.removeFromItems(sourceItems)
            }

            for item in itemsParser.items {
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
