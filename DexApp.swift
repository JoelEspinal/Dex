//
//  DexApp.swift
//  Dex
//
//  Created by Joel Espinal on 10/4/25.
//

import SwiftUI
import SwiftData

@main
struct DexApp: App {
    
    let sharedModelContainer: ModelContainer
    
    init() {
            sharedModelContainer = {
                let schema = Schema([
                    Pokemon.self,
                ])
                let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
                
                do {
                    return try ModelContainer(for: schema, configurations: [modelConfiguration])
                } catch {
                    fatalError("Could not create ModelContainer: \(error)")
                }
            }()
        }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .modelContainer(sharedModelContainer)
            }
        }
    }
}
