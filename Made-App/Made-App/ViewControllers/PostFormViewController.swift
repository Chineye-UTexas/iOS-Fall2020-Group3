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
// import Foundation?
//struct Post{
//    var title: String
//    var arrayOfImages: [UIImage] = []
//    var arrayOfComments: [String] = []
//    var category = String()
//    var description = String()
//    var instructions = String()
//    var postID = String()
//    var postDate = String()
//    var postCaption = String()
//    var nameOfPoster = String()
//    var unit = String()
//    var value = String()
//    var postImageURL = String()
//    var numLikes = String()
//
//}

class PostFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker : UIImagePickerController = UIImagePickerController()

    
    // var nameOfPoster = ""
////    var newPost = Post(title: "", category: "", description: "")
//    var newPost = Post(title: "newPost")

    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectCategory: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var projectInstructions: UITextField!
    @IBOutlet weak var projectValue: UITextField!
    @IBOutlet weak var projectUnit: UITextField!
    var projectImage: String = ""
    @IBOutlet weak var projectDifficulty: UISegmentedControl!
    var difficulty: String = ""
    var newProject: Project?
    var screenName: String = ""
    
    var ref: DatabaseReference! = Database.database().reference()
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // TODO fix and get it to display username
//        self.nameOfPoster = Auth.auth().currentUser?.displayName ?? "Default User"
        
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        print("Post cancelled")
        // send to feed
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        var message = ""
        let title = projectTitle.text ?? ""
        let category = projectCategory.text ?? ""
        let description = projectDescription.text ?? ""
        let instructions = projectInstructions.text ?? ""
        let timeUnit = projectUnit.text ?? ""
        let time = projectValue.text ?? ""
        // let nameOfPoster = self.nameOfPoster
        let images: [String] = [self.projectImage]
        let reviews: [Review] = []
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        let datetime = formatter.string(from: now)
        print(datetime)
        
        // TODO change to fetching url hardcoded image
        // arrayOfImages.append(UIImage(named: "pic-1")!)
        
//        newPost.nameOfPoster = "user name goes here"
//        newPost.title = projectTitle.text ?? "temp title"
//        newPost.category = projectCategory.text ?? ""
//        newPost.description = projectDescription.text ?? ""
//        newPost.instructions = projectInstructions.text ?? ""
//        newPost.unit = projectUnit.text ?? ""
//        newPost.value = projectValue.text ?? ""
//        newPost.nameOfPoster = self.nameOfPoster
//        newPost.postDate = "10/20/2020"
//        newPost.arrayOfImages = arrayOfImages
//        newPost.numLikes = "100"
        
        self.newProject = Project(title: title, category: category, description: description, instructions: instructions, timeValue: Int(time)!, timeUnit: timeUnit, difficulty: self.difficulty, images: images, uniqueID: "", creationDate: datetime, reviews: reviews)
        
        if title.isEmpty {
            message = "Please add a project title"
        }
        if category.isEmpty && message.isEmpty {
            message = "Please add a project category"
        }
        if description.isEmpty && message.isEmpty {
            message = "Please add a project description"
        }
        if instructions.isEmpty && message.isEmpty {
            message = "Please add project instructions"
        }
        if timeUnit.isEmpty && message.isEmpty {
            message = "Please add a project time unit"
        }
        if time.isEmpty && message.isEmpty {
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
        
        // if we make it here , all data is good and needs to be saved to database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name == %@", uniqueID)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [User]
            if let user = fetchedResults.first {
                self.screenName = user.screenName ?? ""
                // store to database under their name
                self.ref.child("users/\(self.screenName)/projects/\(title)/description").setValue(description)
                self.ref.child("users/\(self.screenName)/projects/\(title)/category").setValue(category)
                self.ref.child("users/\(self.screenName)/projects/\(title)/instructions").setValue(instructions)
                self.ref.child("users/\(self.screenName)/projects/\(title)/timeUnit").setValue(timeUnit)
                self.ref.child("users/\(self.screenName)/projects/\(title)/time").setValue(time)
                self.ref.child("users/\(self.screenName)/projects/\(title)/difficulty").setValue(self.difficulty)
                self.ref.child("users/\(self.screenName)/projects/\(title)/images").setValue(images)
                self.ref.child("users/\(self.screenName)/projects/\(title)/reviews").setValue(reviews)
                self.ref.child("users/\(self.screenName)/projects/\(title)/creationTime").setValue(datetime)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the popover
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storageRef = storage.reference()
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let imageName = imageURL.lastPathComponent ?? "image"
        self.projectImage = imageName
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
//        let localPath = documentDirectory + imageName
        
        // File located on disk
        let localURL = URL(string: info[UIImagePickerController.InfoKey.imageURL] as! String)!

        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(imageName).jpg")

        // Upload the file to the path "images/(imageName).jpg"
        let uploadTask = imageRef.putFile(from: localURL, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    // TODO save into Firebase
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
            // change hard code
            // nextVC.posterPhoto = UIImage(named: "pic-1")!
            // nextVC.posterPhoto = newPost.arrayOfImages.first!
            
            // get picture, if one was just uploaded, from firebase storage
            let pathReference = storage.reference(withPath: "images/\(self.projectImage).jpg")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print("error: \(error) occurred, could not get image")
              } else {
                // Data for image is returned
                let image = UIImage(data: data!)
                if image != nil {
                    nextVC.postPhoto = image!
                }
              }
            }
             
            
        }
        
    }
    

}
