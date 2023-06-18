import SwiftUI

struct FeedSourceView: View {

    @ObservedObject var feedSource: FeedSource

    var body: some View {
        Text(feedSource.title)
    }
}

extension FeedSource {

    static func createPreview() -> FeedSource {
        let feedSource = FeedSource(context: PersistenceController.preview.container.viewContext)
        feedSource.title = "Super heros"
        feedSource.link = URL(string: "https://example.com/feed.xml")!
        feedSource.desc = "desc"
        feedSource.fetchedAt = Date()
        feedSource.updatedAt = Date()
        return feedSource
    }
}


struct FeedSourceView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSourceView(feedSource: FeedSource.createPreview())
    }
}
