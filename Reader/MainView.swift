import SwiftUI
import CoreData

struct MainView: View {
    @State private var selectedFeedSource: FeedSource?
    @State private var selectedFeedItem: FeedItem?

    @State var shouldPresentAddSourceView = false
    @State private var visibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            FeedSourceListView(selectionSource: $selectedFeedSource)
        } content: {
            if let feedSource = selectedFeedSource {
                FeedItemListView(feedSource: feedSource, selectedFeedItem: $selectedFeedItem)
            } else {
                Text("Choose a source from the sidebar")
            }
        } detail: {
            NavigationStack {
                if let feedItem = selectedFeedItem {
                    FeedItemDetailView(feedItem: feedItem, visibility: $visibility)
                } else {
                    Text("Choose an item from the content")
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
