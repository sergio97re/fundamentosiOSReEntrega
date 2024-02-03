//
//  LoginViewController.swift
//  DragonBallHeroesPractica
//
//  Created by Sergio Reina Montes on 29/9/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func emailButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        NetworkManager.shared.login(user: email, password: password) { token, error in
            if let token = token {
                DispatchQueue.main.async {
                    UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow } .first?.rootViewController = HeroesListViewController(token: token)
                }
            }else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    

}
