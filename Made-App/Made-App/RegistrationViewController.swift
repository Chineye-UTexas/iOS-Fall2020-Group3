//
//  RegistrationViewController.swift
//  Made-App
//  Course: CS371L
//  Group 3
//
//  Created by Marissa Jenkins on 10/14/20.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    @IBOutlet weak var confirmNewUserPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerDidTouch(_ sender: Any) {
        guard let email = newUserEmail.text,
              let password = newUserPassword.text,
              let confirmPassword = confirmNewUserPassword.text,
              email.count > 7,
              password.count > 7,
              confirmPassword.count > 7 && confirmPassword.count == password.count
        else {
          return
            // display alert error saying they need to either provide
            // an email or password > 7
            // or passwords that match
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password)
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
