import SwiftUI

struct FeedItemDetailView: View {

    @ObservedObject var feedItem: FeedItem
    @Binding var visibility: NavigationSplitViewVisibility

    var body: some View {
        WebView(htmlContent: feedItem.desc)
            .navigationTitle(feedItem.title)
            .toolbar {
                Button("Focus") {
                    visibility = .detailOnly
                }
            }
    }
}

struct FeedItemDetailView_Previews: PreviewProvider {
    @State static var feedItem: FeedItem = FeedItem.createPreview()
    @State static var visibility: NavigationSplitViewVisibility = .all
    static var previews: some View {
        FeedItemDetailView(feedItem: feedItem, visibility: $visibility)
    }
}
