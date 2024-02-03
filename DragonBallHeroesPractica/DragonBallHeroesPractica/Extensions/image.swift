//
//  image.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 29/9/23.
//

import UIKit

extension UIImageView {
    func setImage(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        downloadImage(url: url) { [weak self] image in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    private func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
        
    }
}
