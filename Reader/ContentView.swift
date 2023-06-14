import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FeedSource.title, ascending: true)],
        animation: .default)
    private var feedSources: FetchedResults<FeedSource>
    @State private var selectedFeedSource: FeedSource?
    @State private var selectedFeedItem: FeedItem?

    @State var shouldPresentAddSourceView = false
    @State private var visibility: NavigationSplitViewVisibility = .all

    private func addItem() {
        shouldPresentAddSourceView.toggle()
    }

    private var feedSourceUpdater = FeedSourceUpdater();

    private func fetchContent() async {
        for source in feedSources {
            await feedSourceUpdater.update(source: source, context: viewContext);
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

    }

    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { feedSources[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func delete(feedSource: FeedSource) {
        withAnimation {
            viewContext.delete(feedSource);
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            List(selection: $selectedFeedSource) {
                ForEach(feedSources, id: \.self) { feedSource in
                    NavigationLink(value: feedSource) {
                        Text(verbatim: feedSource.title ?? "Unknown")
                    }
                }
                .onDelete(perform: delete)
            }
            #if os(macOS)
            .contextMenu {
                    Button {
                        if let feedSource = selectedFeedSource {
                            delete(feedSource: feedSource)
                        }
                    } label: {
                        Label("Remove", systemImage: "minus.circle")
                    }
                }
            #endif
            .navigationTitle("Feeds")
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $shouldPresentAddSourceView) {
                        AddSourceView()
                    }
                }
                ToolbarItem {
                    AsyncButton(
                        systemImageName: "arrow.triangle.2.circlepath",
                        action: fetchContent
                    )
                }
            }
        } content: {
            if let selectedFeedSource, let items = selectedFeedSource.items?.allObjects as? [FeedItem] {
                List(selection: $selectedFeedItem) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(value: item) {
                            Text(verbatim: item.title ?? "Unknown")
                        }
                    }
                }
                .navigationTitle(selectedFeedSource.title ?? "Unknown")
            } else {
                Text("Choose a source from the sidebar")
            }
        } detail: {
            NavigationStack {
                ZStack {
                    if let selectedFeedItem {
                        WebView(htmlContent: selectedFeedItem.desc!)
                        .navigationTitle(selectedFeedItem.title ?? "Unknown")
                        .toolbar {
                            Button("Focus") {
                                visibility = .detailOnly
                            }
                        }
                    } else {
                        Text("Choose an item from the content")
                    }
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
