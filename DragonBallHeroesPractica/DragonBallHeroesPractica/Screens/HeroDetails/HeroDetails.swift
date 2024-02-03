//
//  HeroDetails.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 30/9/23.
//

import UIKit

class HeroDetails: UIViewController {
    @IBOutlet weak var imageHeroDetail: UIImageView!
    @IBOutlet weak var tituloHeroDetail: UILabel!
    @IBOutlet weak var descriptionHeroDetail: UILabel!
    @IBOutlet weak var buttonHeroDetail: UIButton!
    
    var heroe: Heroe
    var token: String

    init(heroe: Heroe, token: String){
        self.heroe = heroe
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tituloHeroDetail.text = heroe.name
        self.descriptionHeroDetail.text = heroe.description
        self.imageHeroDetail.setImage(url: heroe.photo)

    }


    @IBAction func buttonDetailAction(_ sender: Any) {
        let transformationsVC = ListHeroTransformationViewController(token: token)
        transformationsVC.getTransformations(token: token, heroParentId: heroe.id)
        print("\(heroe.id)")
        self.navigationController?.pushViewController(transformationsVC, animated: true)
    }
    
}
