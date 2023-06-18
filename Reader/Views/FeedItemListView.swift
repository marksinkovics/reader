import SwiftUI

struct FeedItemListView: View {

    @ObservedObject var feedSource: FeedSource
    @Binding var selectedFeedItem: FeedItem?

    var body: some View {
        if let items = feedSource.items?.allObjects as? [FeedItem] {
            List(selection: $selectedFeedItem) {
                ForEach(items, id: \.self) { item in
                    NavigationLink(value: item) {
                        FeedItemView(feedItem: item)
                    }
                }
            }
            .navigationTitle(feedSource.title)
        } else {
            Text("No feeds")
        }
    }
}

struct FeedItemListView_Previews: PreviewProvider {
    @State static var selectedFeedSource: FeedSource = FeedSource.createPreview()
    @State static var selectedFeedItem: FeedItem?


    static var previews: some View {
        FeedItemListView(feedSource: selectedFeedSource, selectedFeedItem: $selectedFeedItem)
    }
}
