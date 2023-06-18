//
//  FeedItem+CoreDataProperties.swift
//  Reader
//
//  Created by Mark Sinkovics on 2023-06-17.
//
//

import Foundation
import CoreData

extension FeedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItem> {
        return NSFetchRequest<FeedItem>(entityName: "FeedItem")
    }

    @NSManaged public var author: String
    @NSManaged public var desc: String
    @NSManaged public var guid: String
    @NSManaged public var link: URL?
    @NSManaged public var publishedAt: Date
    @NSManaged public var title: String
    @NSManaged public var updatedAt: Date
    @NSManaged public var source: FeedSource

}

extension FeedItem : Identifiable {

}
