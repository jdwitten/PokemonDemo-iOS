//
//  PokemonStore.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation

// Demo - 2: Models, Protocols, and Delegation
class PokemonStore {
    
    var delegate: PokemonDelegate?
    
    private var pokemon: [Pokemon] {
        didSet {
            delegate?.pokemonUpdated(with: pokemon)
        }
    }
    
    init(pokemon: [Pokemon]) {
        self.pokemon = pokemon
    }
    
    public func updatePokemon(_ pokemon: [Pokemon]) {
        self.pokemon = pokemon
    }
}

protocol PokemonDelegate {
    func pokemonUpdated(with pokemon: [Pokemon])
}
