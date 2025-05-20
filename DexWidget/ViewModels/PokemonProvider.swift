//
//  DexWidget.swift
//  DexWidget
//
//  Created by Joel Espinal on 15/4/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct PokemonProvider: TimelineProvider {
    
    var sharedModelContainer: ModelContainer = {
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
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeholder
    }
    
//    typealias Entry = <#T##Type#>
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry.placeholder
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task { @MainActor in
            var entries: [SimpleEntry] = []
            
            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            
            if let results = try?
                            sharedModelContainer.mainContext
                .fetch(FetchDescriptor<Pokemon>()) {
                
                
                for hourOffset in 0 ..< 10 {
                    let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
                    
                    let entryPokemon = results.randomElement()!
                    
                    let entry = SimpleEntry(date: entryDate, name: entryPokemon.name, type: entryPokemon.types, sprite: entryPokemon.spriteImage)
                    
                    entries.append(entry)
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } else {
                let timeline = Timeline(entries: [SimpleEntry.placeholder, SimpleEntry.placehoder2], policy: .atEnd)
                completion(timeline)

            }
        }
    }
}


#Preview(as: .systemSmall) {
    DexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placehoder2
}

#Preview(as: .systemMedium) {
    DexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placehoder2
}

#Preview(as: .systemLarge) {
    DexWidget()
} timeline: {
    SimpleEntry.placeholder
    SimpleEntry.placehoder2
}
