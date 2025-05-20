//
//  DexWidgetEntryView.swift
//  Dex
//
//  Created by Joel Espinal on 20/5/25.
//

import SwiftUI
import WidgetKit

//@main
struct DexWidgetEntryView : WidgetBundle {
    
    var body: some Widget {
        DexWidgetCompilation()
    } 
}

struct DexWidgetCompilation : Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "", provider: PokemonProvider()) { entry in
            if #available(iOS 17.0, *) {
                DexWidgetCompilationView(entry: entry)
                    .foregroundStyle(.black)
                    .containerBackground(Color(entry.type[0].capitalized), for: .widget)
                    .containerBackground(Color(entry.type[0].capitalized), for: .widget)
            } else {
                DexWidgetCompilationView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Pokemon")
        .description("See a random Pokemon.")
    }
}
    
    

struct DexWidgetCompilationView: View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: SimpleEntry
    
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
            .containerBackground(for: .widget) {
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
            .containerBackground(for: .widget) {
            }
            default:
             pokemonImage
            .containerBackground(for: .widget) {
            }
        }
    }
}

