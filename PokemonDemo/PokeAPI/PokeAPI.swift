//
//  PokeAPI.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import Foundation


public protocol PokeAPI {
    func getAllPokemon(_ completion: @escaping ([Pokemon]) -> Void)
    func getPokemonForm(for pokemon: String, _ completion: @escaping (PokemonForm?) -> Void)
    func getImage(for url: String, _ completion: @escaping (Data?) -> Void)
}

class PokeNetworkAPI: PokeAPI {
    let baseURL = "https://pokeapi.co/api/v2/"
    
    func getAllPokemon(_ completion: @escaping ([Pokemon]) -> Void) {
        request(baseURL + "pokemon"){ (data, response, error) in
            guard let data = data, error == nil else {
                return completion([])
            }
            do {
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
    
    private func request(_ string: String, _ completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: string) else {
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
