//
//  ListHeroTransformationViewController.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 30/9/23.
//

import UIKit

class ListHeroTransformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableListTransformations: UITableView!
    
    var token: String
    var allHerosTransf: [TranformationHero] = []
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableListTransformations.dataSource = self
        tableListTransformations.delegate = self
        
        let cell = UINib(nibName: "HeroesCell", bundle: nil)
        tableListTransformations.register(cell, forCellReuseIdentifier: "transformationCell")
        
        
    }
    
    func getTransformations(token: String, heroParentId: String) {
        NetworkManager.shared.transformationHeroesList(token: token, parentHeroId: heroParentId) { transformations, error in
            if let transformations = transformations {
                self.allHerosTransf = transformations
                DispatchQueue.main.async {
                    self.tableListTransformations.reloadData()
                }
            }else {
                print("Error obteniendo las transformaciones: \(error?.localizedDescription ?? "Unknown error")")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allHerosTransf.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transformationCell", for: indexPath) as! HeroesCell
        let transformation = allHerosTransf[indexPath.row]
        cell.nombreHero.text = transformation.name
        cell.descriptionHero.text = transformation.description
        cell.imageHero.setImage(url: transformation.photo)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }


}
