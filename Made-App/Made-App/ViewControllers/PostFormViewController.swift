//
//  PostFormViewController.swift
//  Made-App
//
//  Created by Ira Dhar Gulati on 10/21/20.
//  Code cited from following references: https://stackoverflow.com/questions/39055683/uploading-an-image-from-photo-library-or-camera-to-firebase-storage-swift/39056011, https://www.youtube.com/watch?v=JYkj1UmQ6_g

import UIKit
import Firebase
import CoreData
import AVFoundation

class PostFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker : UIImagePickerController = UIImagePickerController()

    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectCategory: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var projectInstructions: UITextField!
    @IBOutlet weak var projectValue: UITextField!
    @IBOutlet weak var projectUnit: UITextField!
    var projectImage: String = ""
    @IBOutlet weak var projectDifficulty: UISegmentedControl!
    var difficulty: NSString = NSString()
    var newProject: Project?
    var screenName: String = ""
    var projectFirebaseID = ""
    @IBOutlet weak var photoLabel: UIButton!
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        print("Post cancelled")
        // TODO: segue back to feed
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        var message = ""
        let stringTitle = projectTitle.text ?? ""
        let title = NSString(string: projectTitle.text ?? "")
        let category = NSString(string: projectCategory.text ?? "")
        let description = NSString(string: projectDescription.text ?? "")
        let instructions = NSString(string: projectInstructions.text ?? "")
        let timeUnit = NSString(string: projectUnit.text ?? "")
        let time = NSString(string: projectValue.text ?? "")
        // let nameOfPoster = self.nameOfPoster
        let images: NSArray = [self.projectImage]
        let reviews: NSArray = ["this is an example"]
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let datetime = NSString(string: formatter.string(from: now))
        print(datetime)
        
        self.newProject = Project(title: title, category: category,
                                  description: description, instructions: instructions,
                                  timeValue: NSNumber(nonretainedObject: time),
                                  timeUnit: timeUnit, difficulty: self.difficulty, images: images,
                                  creationDate: datetime, reviews: reviews)
        
        if title.length == 0 {
            message = "Please add a project title"
        }
        if category.length == 0 && message.isEmpty {
            message = "Please add a project category"
        }
        if description.length == 0 && message.isEmpty {
            message = "Please add a project description"
        }
        if instructions.length == 0 && message.isEmpty {
            message = "Please add project instructions"
        }
        if timeUnit.length == 0 && message.isEmpty {
            message = "Please add a project time unit"
        }
        if time.length == 0 && message.isEmpty {
            message = "Please add project time value"
        }
        
        if !message.isEmpty {
            let alert = UIAlertController(
              title: "Post Creation Failed",
              message: message,
              preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        print("validated the input")
        // if we make it here , all data is good and needs to be saved to database
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".") // this is their email, but '.' are not allowed in the path
        var projectFirebaseID = self.ref.child("users/\(id[0])/projects/").key
        
        self.ref.child("users/\(id[0])/projects/\(stringTitle)/description").setValue(description)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/category").setValue(category)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/instructions").setValue(instructions)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/timeUnit").setValue(timeUnit)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/time").setValue(time)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/difficulty").setValue(self.difficulty)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/images").setValue(images)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/reviews").setValue(reviews)

        self.ref.child("users/\(id[0])/projects/\(stringTitle)/creationTime").setValue(datetime)
                
    }
    
    
    @IBAction func selectDifficulty(_ sender: Any) {
        switch projectDifficulty.selectedSegmentIndex {
        case 0:
            self.difficulty = "Easy"
        case 1:
            self.difficulty = "Medium"
        case 2:
            self.difficulty = "Hard"
        default:
            self.difficulty = "Easy"
        }
    }
    
    
    @IBAction func attachPhotos(_ sender: Any) {
        // to get access to the photos
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        // change words on screen to reflect photo attached
        // this animates and then goes away
        present(imagePicker, animated: true, completion: nil)
        photoLabel.setTitle("Photo Attached Successfully", for: .normal)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the popover
        dismiss(animated: true, completion: nil)
        photoLabel.setTitle("Attach a Photo", for: .normal)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storageRef = storage.reference()
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let imageName = imageURL.lastPathComponent ?? "image"
        // self.projectImage = NSString(string: imageName)

        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(imageName)")

        // Upload the file to the path "images/(imageName).jpg"
        let uploadTask = imageRef.putFile(from: imageURL as URL, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                self.photoLabel.setTitle("Attach a Photo", for: .normal)
                print("photo did not save")
                return
          }
            print("photo saved")
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("could not get URL: \(String(describing: error))")
                    return
                }
                print(downloadURL.absoluteString)
                self.projectImage = downloadURL.absoluteString
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postCreatedSegueIdentifier",
        let nextVC = segue.destination as? SinglePostViewController {

            nextVC.singlePost = self.newProject!
            nextVC.titleOfPost = self.projectTitle.text
            nextVC.caption = self.projectDescription.text
            nextVC.postName = self.screenName
            nextVC.photoURL = self.projectImage
            nextVC.firebasePostID = self.projectFirebaseID
            
            
            
            // leaving this comment in case we need another way to get the image
//            // get picture, if one was just uploaded, from firebase storage
//            let pathReference = storage.reference(forURL: self.projectImage)
//            pathReference.getData(maxSize: 1 * 2048 * 2048) { data, error in
//              if let error = error {
//                // Uh-oh, an error occurred!
//                print("error: \(error) occurred, could not get image")
//              } else {
//                // Data for image is returned
//                let image = UIImage(data: data!)
//                if image != nil {
//                    nextVC.postPhoto = image!
//                }
//              }
//            }
             
            
        }
        
    }
    

}
