//
//  LoginViewController.swift
//  Made-App
//  Course: CS371L
//  Group 3
//
//  Created by Marissa Jenkins on 10/14/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener() {
          auth, user in
          
          if user != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            self.loginEmail.text = nil
            self.loginPassword.text = nil
          }
        }
    }
    
    @IBAction func loginDidTouch(_ sender: Any) {
        // make sure email/password are at least 7 char long
        guard let email = loginEmail.text,
              let password = loginPassword.text,
              email.count > 7,
              password.count > 7
        else {
          return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
          user, error in
          if let error = error, user == nil {
            let alert = UIAlertController(
              title: "Sign in failed",
              message: error.localizedDescription,
              preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            self.present(alert, animated: true, completion: nil)
          }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
