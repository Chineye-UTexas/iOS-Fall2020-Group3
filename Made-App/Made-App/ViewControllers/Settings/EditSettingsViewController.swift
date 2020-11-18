//
//  EditSettingsViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/19/20.
//

import UIKit
import CoreData
import AVFoundation
import Firebase

protocol ProfilePicChanger {
    func changeProfilePic(newImage: UIImage)
}
class EditSettingsViewController: UIViewController, ProfilePicChanger, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    let picker = UIImagePickerController()
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
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
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss popover
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage = info[.originalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit

        // put the picture into the image view
        imageView.image = chosenImage
        
        let storageRef = storage.reference()
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        print(imageURL)
        let imageName = imageURL.lastPathComponent ?? "image"

        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("profile-photos/\(imageName)")
        var databasePath = ""

        // Upload the file to the path "images/\(imageName)"
        _ = imageRef.putFile(from: imageURL as URL, metadata: nil) { metadata, error in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                print("photo did not save")
                return
          }
            print("photo saved")
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("could not get URL: \(String(describing: error))")
                    return
                }
                databasePath = downloadURL.absoluteString
                self.ref = Database.database().reference()
                let id = uniqueID.split(separator: ".") // this is their email, but '.' are not allowed in the path
                print("saving photo")
                print(databasePath)
                self.ref.child("users/\(id[0])/profilePicture/").setValue(databasePath)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
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
            bio = bioTextField.text!
            currentUser[0].setValue(bioTextField.text!, forKey: "bio")
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
        
        // update profile pic
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")
        var currImageName = ""

        self.ref.child("users/\(id[0])/profilePicture").observeSingleEvent(of: .value, with: {
            (snapshot) in
            currImageName = snapshot.value as! String
            print("curr image in database")
            print(currImageName)
            // set image
            if currImageName != "" {
                self.ref.child("users/\(id[0])/profilePicture").setValue(currImageName)
                // Create a reference from a Google Cloud Storage URI
                let gsReference = self.storage.reference(forURL: currImageName)
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                gsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                  } else {
                    // Data for image path is returned
                    self.imageView.image = UIImage(data: data!)
                  }
                }
            }
        })
        
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
