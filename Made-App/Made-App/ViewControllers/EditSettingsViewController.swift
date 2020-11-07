//
//  EditSettingsViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/19/20.
//

import UIKit
import CoreData

protocol ProfilePicChanger {
    func changeProfilePic(newImage: UIImage)
}
class EditSettingsViewController: UIViewController, ProfilePicChanger {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet var imageView: UIImageView!
    var name = ""
    var bio = ""
    var password = ""
    var notificationState = ""
    var notificationBool = true
    var delegate: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.text = name
        passwordTextField.text = password
        bioTextField.text = bio
        
        if notificationState == "On" {
            notificationSwitch.setOn(true, animated: true)
        } else {
            notificationSwitch.setOn(false, animated: true)
        }
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
        let currentUser = retrieveUser()

        
        if(name != nameTextField!.text!) {
            name = nameTextField.text!
            currentUser[0].setValue(nameTextField.text, forKey: "screenName")
        }
        if (password != passwordTextField.text!) {
            password = passwordTextField.text!
            currentUser[0].setValue(passwordTextField.text!, forKey: "password")
        }
        if (bio != bioTextField.text!) {
            password = passwordTextField.text!
            currentUser[0].setValue("", forKey: "bio")
        }
        if (currentUser[0].notifications != notificationBool) {
            if(currentUser[0].notifications) {
                notificationSwitch.setOn(false, animated: true)
                notificationState = "Off"
                notificationBool = false
                currentUser[0].setValue(false, forKey: "notifications")
            } else {
                notificationSwitch.setOn(true, animated: true)
                notificationState = "On"
                notificationBool = true
                currentUser[0].setValue(true, forKey: "notifications")
            }
        }
        if imageView != nil {
            let otherVC = delegate as! SaveProfilePic
            otherVC.saveProfilePic(newImage: imageView.image!)
        }
    }
    
    func retrieveUser() -> [User] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        

        
        var fetchedResults: [User]? = nil
        let predicate = NSPredicate(format: "name == %@", uniqueID)
        request.predicate = predicate
        do {
            try fetchedResults = context.fetch(request) as? [User]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return fetchedResults!
    }
    
    func changeProfilePic(newImage: UIImage) {
        imageView.image = newImage
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
