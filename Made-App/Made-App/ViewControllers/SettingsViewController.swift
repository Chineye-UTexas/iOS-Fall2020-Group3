//
//  SettingsViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/15/20.
//

import UIKit
import Firebase
import CoreData

protocol SaveProfilePic {
    func saveProfilePic(newImage: UIImage)
}

class SettingsViewController: UIViewController, SaveProfilePic {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadData()
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
    
    func loadData() {
        let currentUser = retrieveUser()
        nameLabel.text = currentUser[0].screenName
        usernameLabel.text = currentUser[0].name
        passwordLabel.text = currentUser[0].password
        bioLabel.text = currentUser[0].bio
        if(currentUser[0].notifications) {
            notificationLabel.text = "On"
        } else {
            notificationLabel.text = "Off"
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do
        {
            try Auth.auth().signOut() //todo add error checks
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
            print(Auth.auth().currentUser?.displayName ?? "User" + " logged out")
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
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
    
    func saveProfilePic(newImage: UIImage) {
        imageView.image = newImage
    }
    
    

}
