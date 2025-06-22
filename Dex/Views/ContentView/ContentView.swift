//
//  ContentView.swift
//  Dex
//
//  Created by Joel Espinal on 10/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(animation: .default) var pokedex: [Pokemon]

    @State private var searchText = ""
    @State private var filterByFavorite: Bool = false

    @State var viewModel: ViewModel = ViewModel()

    
    private var filteredPokedex: [Pokemon] {
        (try? pokedex.filter(dynamicPredicate)) ?? pokedex
    }

    private var dynamicPredicate: Predicate<Pokemon> {
        #Predicate<Pokemon> { pokemon in
            if filterByFavorite && !searchText.isEmpty {
                return pokemon.favorite && pokemon.name.localizedStandardContains(searchText)
            } else if !searchText.isEmpty {
                return pokemon.name.localizedStandardContains(searchText)
            } else if filterByFavorite {
                return pokemon.favorite
            } else {
                return true
            }
        }
    }
    

    var body: some View {
        
        if pokedex.isEmpty {
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
                        ForEach(filteredPokedex) { pokemon in
                            NavigationLink(value: pokemon) {
                                PokemonRow(pokemon: pokemon)
                            }
                            .swipeActions(edge: .leading) {
                                Button(pokemon.favorite ? "Remove from favorites" : "Add to favorites", systemImage: "star") {
                                    toggleFavorite(for: pokemon)
                                }
                            }
                        }
                    } footer: {
                        if pokedex.count < 151 {
                            ContentUnavailableView {
                                Label("Missing Pokemon", image: .nopokemon)
                            } description: {
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
                .animation(.default, value: searchText)
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetail(pokemon: pokemon)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            filterByFavorite.toggle()
                        }
                    } label: {
                        Label("Filter by Favorite", systemImage: filterByFavorite ? "star.fill" : "star")
                    }
                    .tint(.yellow)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }

    private func toggleFavorite(for pokemon: Pokemon) {
        pokemon.favorite.toggle()
        
        viewModel.save()
    }

    private func getPokemon(from id: Int) {
        Task {
            for i in id..<152 {
                let pokemon = await viewModel.fetchPokemon(i)
                if let pokemon {
                    viewModel.insert(pokemon)
                }
            }
            storeSprites()
        }
    }

    private func storeSprites() {
        Task {
            do {
                for pokemon in pokedex {
                    pokemon.sprite = try await URLSession.shared.data(from: pokemon.spriteURL).0
                    pokemon.shiny = try await URLSession.shared.data(from: pokemon.shinyURL).0
                    viewModel.insert(pokemon)
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Pokemon Raw View

struct PokemonRow: View {
    let pokemon: Pokemon

    var body: some View {
        HStack {
            pokemonImageView(for: pokemon)

            VStack(alignment: .leading) {
                HStack {
                    Text(pokemon.name.capitalized)
                        .fontWeight(.bold)
                    if pokemon.favorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                HStack {
                    ForEach(pokemon.types ?? [""], id: \.self) { type in
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

    @ViewBuilder
    private func pokemonImageView(for pokemon: Pokemon) -> some View {
        Group {
            if pokemon.sprite == nil {
                AsyncImage(url: pokemon.spriteURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            } else {
                pokemon.spriteImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
    }
}
