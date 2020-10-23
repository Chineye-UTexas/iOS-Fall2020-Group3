//
//  EditSettingsViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/19/20.
//

import UIKit
import CoreData

class EditSettingsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    var name = ""
    var username = ""
    var bio = ""
    var password = ""
    var notificationState = ""
    var notificationBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.text = name
        usernameTextField.text = username
        passwordTextField.text = password
        bioTextField.text = bio
    }
    @IBAction func changeProfilePicPressed(_ sender: Any) {
        // need to still figure out how to edit profile picture
    }
    
    @IBAction func notificationsButtonPressed(_ sender: Any) {
        if notificationSwitch.isOn {
            // will add implementation to turn off receiving notifications
            notificationSwitch.setOn(false, animated: true)
            notificationState = "Off"
            notificationBool = false
        } else {
            // will add implementation to turn on receiving notifications
            notificationSwitch.setOn(true, animated: true)
            notificationState = "On"
            notificationBool = true
        }
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        // save values to core data storage of user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let user = NSEntityDescription.insertNewObject(
            forEntityName: "User", into:context)
        user.setValue(self.name, forKey: "name")
        user.setValue(self.username, forKey: "screenName")
        user.setValue(self.bio, forKey: "bio")
        user.setValue(self.password, forKey: "password")
        user.setValue(self.notificationBool, forKey: "notification")
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
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
