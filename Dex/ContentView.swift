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
    
    @FetchRequest<Pokemon>(sortDescriptors: []) private var all
    
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
        if all.isEmpty {
            ContentUnavailableView {
                Label("No Pokemons", image: .nopokemon)
            } description: {
                Text("There aren't any Pokemons yet. \nFetch some Pokemon to get started!")
            } actions: {
                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                    getPokemon(from: 1)
                }
                .buttonStyle(.borderedProminent)
            }
            
        } else {
            NavigationStack {
                List {
                    Section {
                        ForEach(pokedex) { pokemon in
                            NavigationLink(value: pokemon) {
                                AsyncImage(url: pokemon.spriteURL) { image in
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
                            }.swipeActions(edge: .leading) {
                                Button(pokemon.favorite ? "Remove from favorites" : "Add to favorites", systemImage: "star") {
                                    pokemon.favorite.toggle()
                                    
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    } footer: {
                        if all.count < 151 {
                            ContentUnavailableView {
                                Label("Missing Pokemon", image: .nopokemon)
                            }  description: {
                                Text("The fetch was interrupted\nFetch the rest of the Pokemon.")
                            } actions: {
                                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                                    getPokemon(from: pokedex.count + 1)
                                }
                                .buttonStyle(.borderedProminent)
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
                    PokemmonDetail().environmentObject(pokemon)
                    
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
            }
              .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
    
    private func getPokemon(from id: Int) {
        Task {
            for i in id..<152 {
                do {
                    let fetchedPokemon = try await fetcher.fetchPokemon(i)
                    
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
                    pokemon.spriteURL = fetchedPokemon.spriteURL
                    pokemon.shinyURL = fetchedPokemon.shinyURL
                    
                    try viewContext.save()
                } catch {
                    print("THERE WAS AN ERROR: \(error)")
                }
            }
            
            storeSprites()
        }
    }
    
    private func storeSprites() {
        Task {
            do {
                for pokemon in all {
                    pokemon.sprite = try await
                    URLSession.shared.data(from: pokemon.spriteURL!).0
                    pokemon.shiny = try await
                    URLSession.shared.data(from: pokemon.shinyURL!).0
                    
                    try viewContext.save()
                }
            } catch {
                print(error)
            }
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
