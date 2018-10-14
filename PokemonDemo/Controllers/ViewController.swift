//
//  ViewController.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PokemonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var store: PokemonStore = PokemonStore(pokemon: [])
    var api: PokeNetworkAPI = PokeNetworkAPI()
    
    var pokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        store.delegate = self
        tableView.rowHeight = 75
        tableView.register(UINib(nibName: "PokemonTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "PokemonTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        api.getAllPokemon { pokemon in
            self.store.updatePokemon(pokemon)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = pokemon[indexPath.row].name
//        return cell
        let thisPokemon = pokemon[indexPath.row]
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell") as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        api.getPokemonForm(for: thisPokemon.name) { pokemonForm in
            if let form = pokemonForm,
                let frontSprite = form.sprites.front_default {
                self.api.getImage(for: frontSprite) { data in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.configure(name: thisPokemon.name, image: UIImage(data: data))
                        }
                    }
                }
            }
        }
        cell.configure(name: thisPokemon.name, image: nil)
        return cell
        
    }
    
    func pokemonUpdated(with pokemon: [Pokemon]) {
        DispatchQueue.main.async {
            self.pokemon = pokemon
            self.tableView.reloadData()
        }
    }
}

