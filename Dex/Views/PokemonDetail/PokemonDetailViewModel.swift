//
//  ViewModel.swift
//  Dex
//
//  Created by Joel Espinal on 22/6/25.
//

import Observation
import SwiftData


extension PokemonDetail {
    
    @MainActor
    @Observable
    class PokemonDetailViewModel {
        
        private var modelContainer: ModelContainer?

        func modelContext(_ modelContext: ModelContainer?) {
            if let modelContext = modelContext {
                self.modelContainer = modelContext
            }
       }
        
        func save() {
            try? modelContainer?.mainContext.save()
        }

    }
}
