import SwiftUI
import CoreData

struct FeedSourceListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FeedSource.title, ascending: true)],
        animation: .default)
    private var feedSources: FetchedResults<FeedSource>
    @State var shouldPresentAddSourceView = false

    @Binding var selectedFeedSource: FeedSource?

    private func addItem() {
        shouldPresentAddSourceView.toggle()
    }

    private var feedSourceUpdater = FeedSourceUpdater();

    init(selectionSource: Binding<FeedSource?>) {
        _selectedFeedSource = selectionSource
    }

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
        List(selection: $selectedFeedSource) {
            ForEach(feedSources, id: \.self) { feedSource in
                NavigationLink(value: feedSource) {
                    FeedSourceView(feedSource: feedSource)
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
    }
}

struct FeedSourceListView_Previews: PreviewProvider {
    @State static var selectedFeedSource: FeedSource?
    static var previews: some View {
        FeedSourceListView(selectionSource: $selectedFeedSource)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
