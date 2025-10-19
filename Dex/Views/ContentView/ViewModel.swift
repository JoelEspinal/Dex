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
        
        private var modelContainer: ModelContext? = nil
        private let fetchService: FetchService = FetchService()
        var pokedex = [Pokemon]()
        var favorites = [Pokemon]()

        
        func modelContext(_ modelContext: ModelContext?) async {
            if let modelContext = modelContext {
                self.modelContainer = modelContext
                await fetchFromDB()
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
        
        func save()  {
            do {
                try modelContainer?.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
        
        func insert(_ pokemon: Pokemon) {
            modelContainer?.insert(pokemon)
        }
        
        func fetchFromDB() async {
            do {
                if pokedex.isEmpty {
                    let pokemonArray = try modelContainer?.fetch(FetchDescriptor<Pokemon>())
                    pokedex = pokemonArray ?? []
                }
            } catch {
                print("Error fetching Pokemon: \(error)")
            }
        }
        
        func initPokedex() async {
            await fetchFromDB()
            
            if pokedex.isEmpty {
                await getPokemons()
            }
        }
        
        func getPokemons() async {
            for i in 1..<152 {
                if let pokemon = await fetchPokemon(i) {
                    insert(pokemon)
                }
            }
            save()
        }
        
        func searchFavorites(_ searchText: String) {
            favorites = pokedex.filter({
                ($0.favorite == true && $0.name.localizedStandardContains(searchText))
                || ($0.name.localizedStandardContains(searchText))
                || $0.favorite == true
            })
        }
    }
}
