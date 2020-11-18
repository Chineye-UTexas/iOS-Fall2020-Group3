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
import CoreData
import Foundation

var uniqueID: String = ""

class RegistrationViewController: UIViewController {

    @IBOutlet weak var newUserEmail: UITextField!
    @IBOutlet weak var newUserPassword: UITextField!
    @IBOutlet weak var confirmNewUserPassword: UITextField!
    @IBOutlet weak var newUserScreenName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerDidTouch(_ sender: Any) {
        var message = ""
        
        let email = newUserEmail.text ?? ""
        let password = newUserPassword.text ?? ""
        let confirmPassword = confirmNewUserPassword.text ?? ""
        let screenName = newUserScreenName.text ?? ""
        
        if email.isEmpty || !(email.count > 7) {
            message = "Account email should be at least 7 characters"
        }
        if password.isEmpty || !(password.count > 7) && message.isEmpty {
            message = "Password should be at least 7 characters"
        }
        if password != confirmPassword && message.isEmpty {
            message = "Password and Confirm Password fields should match"
        }
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_")
        if screenName.rangeOfCharacter(from: characterset.inverted) != nil && message.isEmpty {
            message = "Screen name cannot contain special characters"
        }
        // no longer than 8 chars long , only letters & number, - , _
        if screenName.count > 8 && message.isEmpty {
            message = "Screen name cannot be longer than 8 characters"
        }
        
        if !message.isEmpty {
            let alert = UIAlertController(
              title: "Sign in failed",
              message: message,
              preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password)
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                  }
                // save user data to core data
                let managedContext = appDelegate.persistentContainer.viewContext
                print("before get entity")
                let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
                let user = NSManagedObject(entity: entity, insertInto: managedContext)
                print("after get user")
                // figure out where to delete this information .. ? never
                user.setValue(email, forKey: "name")
                uniqueID = email
                user.setValue(self.newUserScreenName.text, forKey: "screenName")
                user.setValue(false, forKey: "notifications")
                user.setValue(self.newUserPassword.text, forKey: "password")
                user.setValue("", forKey: "bio")

                do {
                    try managedContext.save()
                  } catch let error as NSError {
                    print("Could not save user data. \(error), \(error.userInfo)")
                  }
                
                // save to firebase database
                var ref: DatabaseReference!
                ref = Database.database().reference()
                let emailID = uniqueID.split(separator: ".")
                let uid = Auth.auth().currentUser!.uid
                ref.child("users/\(emailID[0])/uid").setValue(uid)
                ref.child("users/\(emailID[0])/profilePicture").setValue("gs://made-ios.appspot.com/profile-photos/gray.jpg")
                
                self.newUserEmail.text = nil
                self.newUserPassword.text = nil
                self.confirmNewUserPassword.text = nil
                self.newUserScreenName.text = nil
                
                self.performSegue(withIdentifier: "registerSegue", sender: nil)
            } else {
                // display alert error and update status
                let alert = UIAlertController(
                  title: "Sign up failed",
                    message: error?.localizedDescription,
                  preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK",style:.default))
                self.present(alert, animated: true, completion: nil)
                return
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
