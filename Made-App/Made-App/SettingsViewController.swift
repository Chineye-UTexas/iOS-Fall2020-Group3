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
    @IBOutlet weak var notificationsState: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func notificationsToggle(_ sender: Any) {
        if notificationsState.isOn {
            // will add implementation to turn off receiving notifications
            notificationsState.setOn(false, animated: true)
        } else {
            // will add implementation to turn on receiving notifications
            notificationsState.setOn(true, animated: true)
        }
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
        }
    }
    

}
