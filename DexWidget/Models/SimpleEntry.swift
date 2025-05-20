//
//  SimpleEntry.swift
//  Dex
//
//  Created by Joel Espinal on 20/5/25.
//

import SwiftUI
import WidgetKit

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

