import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text("Settings")
            }
            #if os(iOS)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Dismiss", action: {dismiss()})
                }
            }
            #endif
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
