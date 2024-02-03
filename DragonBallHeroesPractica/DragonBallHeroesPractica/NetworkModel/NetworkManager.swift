//
//  NetworkManager.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 29/9/23.
//

import Foundation

final class NetworkManager {
    
    enum NetworkError: Error {
        case unknown
        case malformedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
        case noToken
    }
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(user: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/auth/login") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        let loginString = "\(user):\(password)"
        let loginData = loginString.data(using: .utf8)!
        let base64 = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                completion(nil, NetworkError.statusCode(code: statusCode))
                return
            }
            guard let token = String(data: data, encoding: .utf8) else {
                completion(nil, NetworkError.noToken)
                return
            }
            
            completion(token, nil)
        }
        task.resume()
    }
    
    func heroesList(token: String?, completion: @escaping ([Heroe]?, Error?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            guard let heroes = try? JSONDecoder().decode([Heroe].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            completion(heroes, nil)
        }
        task.resume()
    }
    
    func transformationHeroesList(token: String?, parentHeroId: String?, completion: @escaping ([TranformationHero]?, Error?) -> Void) {
        guard let url = URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations") else {
            completion(nil, NetworkError.malformedUrl)
            return
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "id", value: "\(parentHeroId ?? "")")]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = urlComponents.query?.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                print("StatusCode \(statusCode)")
                completion(nil, NetworkError.statusCode(code: statusCode))
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noData)
                return
            }
            guard let heroes = try? JSONDecoder().decode([TranformationHero].self, from: data) else {
                completion(nil, NetworkError.decodingFailed)
                return
            }
            completion(heroes, nil)
            print("\(heroes)")
        }
        task.resume()
    }
    

}
