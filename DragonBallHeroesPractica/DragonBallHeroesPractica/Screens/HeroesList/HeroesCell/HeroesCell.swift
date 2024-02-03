//
//  HeroesCell.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 29/9/23.
//

import UIKit

class HeroesCell: UITableViewCell {

    @IBOutlet weak var imageHero: UIImageView!
    @IBOutlet weak var nombreHero: UILabel!
    @IBOutlet weak var descriptionHero: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
