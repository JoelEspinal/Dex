//
//  DexWidget.swift
//  DexWidget
//
//  Created by Joel Espinal on 15/4/25.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    
    var randomPokemon : Pokemon {
        var results: [Pokemon] = []
        
        do {
            results = try PersistenceController.shared.container
                .viewContext.fetch(Pokemon.fetchRequest())
            
        } catch {
            print("Couldn'n fetch. \(error)")
        }
        
        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        
        return PersistenceController.previewPokemon
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeholder
    }
//    typealias Entry = <#T##Type#>
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry.placeholder
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 10 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            
            let entryPokemon = randomPokemon
            
            let entry = SimpleEntry(date: entryDate, name: entryPokemon.name!, type: entryPokemon.types!, sprite: entryPokemon.spriteImage)
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
//    let emoji: String
    let name: String
    let type: [String]
    let sprite: Image
    
    static var placeholder = SimpleEntry(date: .now,
                             name: "bulbasaurs", type: ["grass", "pointer"],
                             sprite: Image(.bulbasaur))

    static var placehoder2: SimpleEntry {
        SimpleEntry(date: .now,
                             name: "bulbasaurs", type: ["mew"],
                             sprite: Image(.mew))

    }
}

struct DexWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry
    
    var pokemonImage: some View {
        entry.sprite
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .shadow(color: .black,   radius: 6)
    }
    
    var typeView: some View {
        ForEach(entry.type, id: \.self) { type in
            Text(type.capitalized)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.horizontal, 13)
                .padding(.vertical, 5)
                .background(Color(type.capitalized))
                .clipShape(.capsule)
                .shadow(radius: 3)
        }
    }

    var body: some View {
        switch widgetSize {
            case .systemMedium:
            HStack {
                pokemonImage
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text(entry.name.capitalized)
                        .font(.title)
                        .padding(.vertical, 1)
                    HStack {
                        typeView
                    }
                }
                .layoutPriority(1)
                
                Spacer()
                
                
            }
            
            case .systemLarge:
            ZStack {
                pokemonImage
                
                VStack(alignment: .leading) {
                    Text(entry.name.capitalized)
                        .font(.largeTitle)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        ForEach(entry.type, id: \.self) { type in
                            Text(type.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(Color(type.capitalized))
                                .clipShape(.capsule)
                                .shadow(radius: 3)
                        }
                    }
                }
            }
            default:
             pokemonImage
        }
       
    }
}

struct DexWidget: Widget {
    let kind: String = "DexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DexWidgetEntryView(entry: entry)
                    .foregroundStyle(.black)
                    .containerBackground(Color(entry.type[0].capitalized), for: .widget)
            } else {
                DexWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pokemon")
        .description("See a random Pokemon.")
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
