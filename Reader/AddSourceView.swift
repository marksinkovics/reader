import SwiftUI

struct AddSourceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context

    @State var sourceURL: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text("Add new source URL")
                    .font(.title)

                TextField(text: $sourceURL, prompt: Text("http://example.com/feed.xml")) {
                    Text("Title")
                }
            }
            .padding(20)
            .frame(width: 300, height: 200)
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Save", action: saveSource)
                }
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Cancel", action: cancel)
                }
            }
        }
    }

    private func saveSource() {

        let newFeedSource = FeedSource(context: context)
        newFeedSource.title = "No name"
        newFeedSource.createdAt = Date()
        newFeedSource.fetchedAt = Date()
        newFeedSource.updatedAt = Date()
        newFeedSource.url = URL(string: sourceURL)!

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        dismiss();
    }

    private func cancel() {
        dismiss()
    }
}

struct AddSourceView_Previews: PreviewProvider {
    static var previews: some View {
        AddSourceView()
    }
}
