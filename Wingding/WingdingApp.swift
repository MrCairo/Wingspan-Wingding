//
//  WingdingApp.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/9/25.
//

import SwiftData
import SwiftUI

@main
struct WingdingApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationLink("Manage Decks") {
                    ContentView()
                }
            }
            .modelContainer(for: [Deck.self])
        }
    }
}
