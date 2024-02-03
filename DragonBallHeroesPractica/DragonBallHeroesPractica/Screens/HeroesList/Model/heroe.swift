//
//  heroe.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 29/9/23.
//

import Foundation

struct Heroe: Codable {
    let name: String
    let id: String
    let description: String
    let favorite: Bool
    let photo: String
}

struct TranformationHero: Codable {
    let name: String
    let id: String
    let description: String
    let photo: String
}
