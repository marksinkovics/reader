import Foundation
import CoreData

extension FeedSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedSource> {
        return NSFetchRequest<FeedSource>(entityName: "FeedSource")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var desc: String
    @NSManaged public var fetchedAt: Date
    @NSManaged public var link: URL?
    @NSManaged public var title: String
    @NSManaged public var updatedAt: Date
    @NSManaged public var url: URL
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension FeedSource {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: FeedItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: FeedItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension FeedSource : Identifiable {

}
