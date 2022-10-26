//
//  GirisViewController.swift
//  YavuzMessenger
//
//  Created by iOS PSI on 24.10.2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButton(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let er = error {
                    print(er.localizedDescription)
                }else{
                    self.performSegue(withIdentifier: K.loginSegue, sender: nil)
                }
            }
        }
        
        
        
    }
   
    @IBAction func googleLogin(_ sender: Any) {
        
    }
    
}
