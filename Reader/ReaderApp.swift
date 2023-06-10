//
//  ReaderApp.swift
//  Reader
//
//  Created by Mark Sinkovics on 2023-06-10.
//

import SwiftUI

@main
struct ReaderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
