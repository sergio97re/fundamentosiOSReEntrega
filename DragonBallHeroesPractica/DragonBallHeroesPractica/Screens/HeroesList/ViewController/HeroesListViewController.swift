//
//  HeroesListViewController.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 29/9/23.
//

import UIKit

class HeroesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var token: String
    var allHeros: [Heroe] = []
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var tableHeroes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeroes.dataSource = self
        tableHeroes.delegate = self
        
        let cell = UINib(nibName: "HeroesCell", bundle: nil)
        tableHeroes.register(cell, forCellReuseIdentifier: "customCell")
        
        getHeroes(token: token)

    }
    
    func getHeroes(token: String) {
        NetworkManager.shared.heroesList(token: token) { heroes, error in
            if let heroes = heroes {
                self.allHeros = heroes
                DispatchQueue.main.async {
                    self.tableHeroes.reloadData()
                }
            }else {
                print("Error en conseguir los heroes!!")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allHeros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! HeroesCell
        let heroe = allHeros[indexPath.row]
        cell.nombreHero.text = heroe.name
        cell.descriptionHero.text = heroe.description
        cell.imageHero.setImage(url: heroe.photo)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroe = allHeros[indexPath.row]
        
        let detailsHero = HeroDetails(heroe: heroe, token: self.token)
        
        // Envolvemos HeroDetails dentro de un UINavigationController
        let navController = UINavigationController(rootViewController: detailsHero)
        
        // Ahora, presentamos el UINavigationController
        self.present(navController, animated: true, completion: nil)
    }


}
