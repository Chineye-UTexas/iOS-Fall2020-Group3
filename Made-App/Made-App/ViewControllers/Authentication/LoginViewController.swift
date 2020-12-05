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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 5
        self.registrationButton.layer.cornerRadius = 5
    }
    
    
    @IBAction func loginDidTouch(_ sender: Any) {
            print("login")
            // check credentials & sign in
            Auth.auth().signIn(withEmail: loginEmail.text!, password: loginPassword.text!) {
              user, error in
                print(self.loginEmail.text!)
                print(self.loginPassword.text!)
                print("check credentials")
              if let error = error, user == nil {
                print("found an error")
                let alert = UIAlertController(
                  title: "Sign in failed",
                  message: error.localizedDescription,
                  preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK",style:.default))
                self.present(alert, animated: true, completion: nil)
                print("after alert, before return")
                return
              } else {
                print("every thing is fine")
                uniqueID = self.loginEmail.text!
                self.loginEmail.text = nil
                self.loginPassword.text = nil
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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
