//
//  ViewModel.swift
//  Dex
//
//  Created by Joel Espinal on 21/6/25.
//

import Observation
import SwiftData


extension ContentView {
    
    @MainActor
    @Observable
    class ViewModel {
        
        private var modelContext: ModelContainer?
        private let fetchService: FetchService = FetchService()
        
//        init (modelContext: ModelContainer?) {
//            if let modelContext = modelContext {
//                self.modelContext = modelContext
//            }
//        }
        
        func modelContext(_ modelContext: ModelContainer?) {
            if let modelContext = modelContext {
                self.modelContext = modelContext
            }
       }
        
        
        func fetchPokemon(_ id: Int) async -> Pokemon? {
            do {
                let pokemon = try await fetchService.fetchPokemon(id)
                return pokemon
            } catch {
                print("Error fetching Pokemon: \(error)")
            }
            
            return nil
        }
        
        
        //  Storage Methods
        func save()  {
            do {
                try modelContext?.mainContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
        
        func insert(_ pokemon: Pokemon) {
            modelContext?.mainContext.insert(pokemon)
        }
    }
}
