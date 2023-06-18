import SwiftUI

class FeedItemDateFormatter: DateFormatter {

    override init() {
        super.init()
        self.locale = Locale.autoupdatingCurrent
        self.dateStyle = .short
        self.timeStyle = .short
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.locale = Locale.autoupdatingCurrent
        self.dateStyle = .short
        self.timeStyle = .short
    }
}

struct FeedItemView: View {

    @ObservedObject var feedItem: FeedItem
    let dateFormatter = FeedItemDateFormatter()

    var body: some View {

        VStack {
            Text(feedItem.title)
                .font(.body)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.bottom], 0.5)
            HStack {
                Text(feedItem.author)
                    .font(.footnote)
                Spacer()
                Text(feedItem.updatedAt, formatter: dateFormatter)
                    .font(.footnote)
            }

        }
    }
}

extension FeedItem {

    static func createPreview() -> FeedItem {
        let feedItem = FeedItem(context: PersistenceController.preview.container.viewContext)
        feedItem.title = "What's new in ???"
        feedItem.link = URL(string: "https://example.com")
        feedItem.author = "Mr. Smith"
        feedItem.publishedAt = Date()
        feedItem.updatedAt = Date()
        feedItem.guid = "uuid"
        feedItem.desc = "This is a recap what was announched last week at..."
        return feedItem
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(feedItem: FeedItem.createPreview())
    }
}
