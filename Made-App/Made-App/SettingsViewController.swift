//
//  SettingsViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/15/20.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
//        do {
//            Auth.auth().signOut()
//        } catch (error) {
//            console.log(error)
//        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSettingsSegue",
        let nextVC = segue.destination as? EditSettingsViewController {
            nextVC.name = nameLabel.text!
            nextVC.username = usernameLabel.text!
            nextVC.password = passwordLabel.text!
            nextVC.bio = bioLabel.text!
            nextVC.notificationState = notificationLabel.text!
        }
    }
    

}
