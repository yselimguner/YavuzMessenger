//
//  KayitOlViewController.swift
//  YavuzMessenger
//
//  Created by iOS PSI on 24.10.2022.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButton(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let er = error {
                    print(er.localizedDescription)
                }else{
                    //Kayıt olduktan sonra chatViewController'a git diyor.
                    self.performSegue(withIdentifier: K.registerSegue, sender: nil)
                }
            }
        }
    }
}
