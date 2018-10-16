//
//  PokemonTableViewCell.swift
//  PokemonDemo
//
//  Created by Jonathan Witten on 10/13/18.
//  Copyright © 2018 Jonathan Witten. All rights reserved.
//

import UIKit

// Demo - 9: Using Interface Builder to create custom views with outlets
class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(name: String, image: UIImage?) {
        nameLabel.text = name
        pokemonImage.image = image
    }
    
}
