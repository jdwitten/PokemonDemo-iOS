//
//  Pokemon.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation

public struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonResponse: Codable {
    let count: Int?
    let next: Int?
    let previous: Int?
    let results: [Pokemon]
}

public struct PokemonForm: Codable {
    let sprites: PokemonSprites
}

struct PokemonSprites: Codable {
    let back_default: String?
    let back_shiny: String?
    let front_default: String?
    let front_shiny: String?
}

