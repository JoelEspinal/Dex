//
//  PokemmonDetail.swift
//  Dex
//
//  Created by Joel Espinal on 14/4/25.
//

import SwiftUI

struct PokemonDetail: View {
    
    @Environment(\.modelContext) private var modelContext
 
    var pokemon: Pokemon
    
    @State private var showShiny: Bool = false
    
    var body: some View {
      ScrollView {
          ZStack {
              Image(pokemon.background)
                  .resizable()
                  .scaledToFit()
                  .shadow(color: .black, radius: 6)
              if pokemon.sprite == nil || pokemon.shiny == nil {
                  AsyncImage(url: showShiny ? pokemon.shinyURL : pokemon.spriteURL) { image in
                      image
                          .interpolation(.none)
                          .resizable()
                          .scaledToFit()
                          .padding(.top, 50)
                          .shadow(color: .black, radius: 6)
                  } placeholder: {
                      ProgressView()
                  }
              } else {
                  (showShiny ? pokemon.shyniImage : pokemon.spriteImage)
              }
          }
          
          HStack {
              ForEach(pokemon.types, id: \.self) { type in
                  Text(type.capitalized)
                      .font(.title2)
                      .fontWeight(.semibold)
                      .foregroundStyle(.black)
                      .shadow(color: .white, radius: 1)
                      .padding(.vertical, 7)
                      .padding(.horizontal)
                      .background(Color(type.capitalized))
                      .clipShape(.capsule)
              }
              
              Spacer()
              
              Button {
                  pokemon.favorite.toggle()
                  
                  do {
                      try modelContext.save()
                  } catch {
                      print(error)
                  }
                  
              } label: {
                  Image(systemName: pokemon.favorite ? "star.fill" : "star")
                      .font(.largeTitle)
                      .tint(.yellow)
              }
          }
          .padding()
          
          Text("Stats")
              .font(.title)
              .padding(.bottom, -7)
          
          Stats(pokemon: pokemon)
      }
      .navigationTitle(pokemon.name.capitalized)
      .toolbar {
          Button {
              showShiny.toggle()
          } label: {
              Image(systemName: showShiny ?
                    "wand.and.stars" :
                    "wand.and.stars.inverse")
              .tint(showShiny ? .yellow : .primary)
          }
      }
    }
}

//#Preview {
//    NavigationStack {
//        PokemonDetail(pokemon:
//                        PersistenceController.previewPokemon)
//        
//    }
//}
