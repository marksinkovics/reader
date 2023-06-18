import SwiftUI

#if os(macOS)
// https://www.optionalmap.com/posts/swiftui_single_window_app/
// https://onmyway133.com/posts/how-to-manage-windowgroup-in-swiftui-for-macos/
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        return true;
    }
}
#endif

@main
struct ReaderApp: App {
    @Environment(\.openWindow) var openWindow

    let persistenceController = PersistenceController.shared
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
#endif

    var body: some Scene {
        WindowGroup("", id: "reader_app.main") {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #if os(iOS)
        WindowGroup("Settings", id: "reader_app.settings") {
            SettingsView()
        }
        #else
        Window("Settings", id: "reader_app.settings") {
            SettingsView()
        }
        .commands {
            CommandGroup(replacing: .systemServices) {
                Button("Settings...") {
                    openWindow(id: "reader_app.settings")
                }
                .keyboardShortcut(",")
            }
            CommandGroup(replacing: .newItem) {}
        }
        #endif
    }
}
