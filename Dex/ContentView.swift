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
    
    @FetchRequest<Pokemon>(
        sortDescriptors: [SortDescriptor(\.id)],
        animation: .default
    ) private var pokedex
    
    @State private var searchText = ""
    @State private var filterByFavorite: Bool = false
    
    let fetcher = FetchService()
    
    private var dynamicPredicate: NSPredicate {
        var predicates: [NSPredicate] = []
        
        // Search predicate
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
        }
        
        // FilterByFavorite predicate
        if filterByFavorite {
            predicates.append(NSPredicate(format: "favorite == %d", true))
        }
        
        // CombinePredicates
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
    }
    
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
                                HStack {
                                    Text(pokemon.name!.capitalized)
                                        .fontWeight(.bold)
                                    
                                    if pokemon.favorite {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                    }
                                    
                                }
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
            .searchable(text: $searchText, prompt: "Find a Pokemon")
            .autocorrectionDisabled()
            .onChange(of: searchText) {
                pokedex.nsPredicate = dynamicPredicate //(for: searchText)
            }
            .onChange(of: filterByFavorite) {
                pokedex.nsPredicate = dynamicPredicate
            }
            .navigationDestination(for: Pokemon.self) { pokemon in
                Text(pokemon.name ?? "No Name")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    filterByFavorite.toggle()
                } label: {
                    Label("Filter by Favorite", systemImage: filterByFavorite ? "star.fill" : "star")
                }
                .tint(.yellow)
                
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
