//
//  ContentView.swift
//  Dex
//
//  Created by Joel Espinal on 10/4/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    
    private var pokedex: FetchedResults<Pokemon>
    let fetcher = FetchService()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text(pokemon.name!.capitalized)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    ForEach(pokemon.types!, id: \.self) { type in
                                        Text(type.capitalized)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 13)
                                            .padding(.vertical, 5)
                                            .background(Color(type.capitalized))
                                            .clipShape(.capsule)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Pokedex"))
            .navigationDestination(for: Pokemon.self) { pokemon in
                Text(pokemon.name ?? "No Name")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                #if os(iOS)
                EditButton()
                #endif
            }
            ToolbarItem {
                Button("Add Item", systemImage: "plus") {
                    getPokemon()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func getPokemon() {
        Task {
            for id in 1..<152 {
                do {
                    let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    
                    let pokemon = Pokemon(context: viewContext)
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.types = fetchedPokemon.types
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defense = fetchedPokemon.defense
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefence = fetchedPokemon.specialDefense
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.shiny = fetchedPokemon.shiny
                    
                    try viewContext.save()
                } catch {
                    print("THERE WAS AN ERROR: \(error)")
                }
            }
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
