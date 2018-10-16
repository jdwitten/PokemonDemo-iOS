//
//  ViewController.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import UIKit

// Demo - 1: ViewControllers, Storyboards, and TableViews
class PokemonViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PokemonDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var store: PokemonStore = PokemonStore(pokemon: [])
    var api: PokeNetworkAPI = PokeNetworkAPI()
    
    var pokemon: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Demo - 6: TableViewDataSource and delegation
        tableView.delegate = self
        tableView.dataSource = self
        
        
        store.delegate = self
        
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "PokemonTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "PokemonTableViewCell")
    }
    
    // Demo - 3: ViewController life cycle and loading data
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        api.getAllPokemon { pokemon in
            self.store.updatePokemon(pokemon)
        }
    }
    
    // Demo - 7: Loading Data into a TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = pokemon[indexPath.row].name
        
// Demo - 8: Custom Views/TableViewCells
        let cell = createCustomPokemonCell(indexPath)
        return cell
    }
    
    func pokemonUpdated(with pokemon: [Pokemon]) {
        DispatchQueue.main.async {
            self.pokemon = pokemon
            self.tableView.reloadData()
        }
    }
    
    func createCustomPokemonCell(_ indexPath: IndexPath) -> UITableViewCell {
        let thisPokemon = pokemon[indexPath.row]
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell") as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        loadPokemonImage(into: cell, for: thisPokemon.name)
        return cell
    }
    
    func loadPokemonImage(into cell: PokemonTableViewCell, for name: String) {
        api.getPokemonForm(for: name) { pokemonForm in
            if let form = pokemonForm,
                let frontSprite = form.sprites.front_default {
                self.api.getImage(for: frontSprite) { data in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.configure(name: name, image: UIImage(data: data))
                        }
                    }
                }
            }
        }
    }
}

