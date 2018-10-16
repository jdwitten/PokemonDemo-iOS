//
//  PokeAPI.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation

// Demo - 4: Closures
public protocol PokeAPI {
    func getAllPokemon(_ completion: @escaping ([Pokemon]) -> Void)
    func getPokemonForm(for pokemon: String, _ completion: @escaping (PokemonForm?) -> Void)
    func getImage(for url: String, _ completion: @escaping (Data?) -> Void)
}

class PokeNetworkAPI: PokeAPI {
    let baseURL = "https://pokeapi.co/api/v2/"
    
    // Demo - 5: Making Network Requests
    func getAllPokemon(_ completion: @escaping ([Pokemon]) -> Void) {
        request(baseURL + "pokemon"){ (data, response, error) in
            guard let data = data, error == nil else {
                return completion([])
            }
            do {
                // Demo - 5: Decoding JSON
                let response = try JSONDecoder().decode(PokemonResponse.self, from: data)
                return completion(response.results)
            } catch {
                return completion([])
            }
        }
    }
    
    func getPokemonForm(for pokemon: String,_ completion: @escaping (PokemonForm?) -> Void) {
        request(baseURL + "pokemon-form/" + pokemon) { (data, response, error) in
            guard let data = data, error == nil else {
                return completion(nil)
            }
            do {
                let response = try JSONDecoder().decode(PokemonForm.self, from: data)
                return completion(response)
            } catch {
                return completion(nil)
            }
        }
    }
    
    func getImage(for url: String, _ completion: @escaping (Data?) -> Void) {
        request(url) { (data, response, error) in
            return completion(data)
        }
    }
    
    private func request(_ urlString: String, _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(nil, nil, APIError.invalidURL)
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}

enum APIError: Error {
    case invalidURL
}
