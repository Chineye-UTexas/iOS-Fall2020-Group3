//
//  PostFormViewController.swift
//  Made-App
//
//  Created by Ira Dhar Gulati on 10/21/20.
//  Code cited from following references: https://stackoverflow.com/questions/39055683/uploading-an-image-from-photo-library-or-camera-to-firebase-storage-swift/39056011, https://www.youtube.com/watch?v=JYkj1UmQ6_g

import UIKit
import Firebase
import CoreData
// import Foundation?
struct Post{
    var title: String
    var arrayOfImages: [UIImage] = []
    var arrayOfComments: [String] = []
    var category = String()
    var description = String()
    var instructions = String()
    var postID = String()
    var postDate = String()
    var postCaption = String()
    var nameOfPoster = String()
    var unit = String()
    var value = String()
    var postImageURL = String()
    var numLikes = String()
    
}

class PostFormViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imagePicker : UIImagePickerController = UIImagePickerController()

    
    var nameOfPoster = ""
//    var newPost = Post(title: "", category: "", description: "")
    var newPost = Post(title: "newPost")

    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectCategory: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    @IBOutlet weak var projectInstructions: UITextField!
    @IBOutlet weak var projectValue: UITextField!
    @IBOutlet weak var projectUnit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // TODO fix and get it to display username
        self.nameOfPoster = Auth.auth().currentUser?.displayName ?? "Default User"
        
    }
    /* @IBAction func addPictureBtnAction(_ sender: Any) {
        //addPictureBtn.enabled = false

        let alertController : UIAlertController = UIAlertController(title: "Title", message: "Select Camera or Photo Library", preferredStyle: .actionSheet)
        let cameraAction : UIAlertAction = UIAlertAction(title: "Camera", style: .default, handler: {(cameraAction) in
                print("camera Selected...")

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == true {

                self.imagePicker.sourceType = .camera
                    self.present()

                }else{
                    self.present(self.showAlert(Title: "Title", Message: "Camera is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)

                }

            })

        let libraryAction : UIAlertAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(libraryAction) in

                print("Photo library selected....")

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) == true {

                self.imagePicker.sourceType = .photoLibrary
                    self.present()

                }else{

                    self.present(self.showAlert(Title: "Title", Message: "Photo Library is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
                }
            })

        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel , handler: {(cancelActn) in
            print("Cancel action was pressed")
            })

            alertController.addAction(cameraAction)

            alertController.addAction(libraryAction)

            alertController.addAction(cancelAction)

            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.frame

        self.present(alertController, animated: true, completion: nil)
    }
    
    func present(){

        self.present(imagePicker, animated: true, completion: nil)

    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
         print("info of the pic reached :\(info) ")
        self.imagePicker.dismiss(animated: true, completion: nil)

    }
    
    func showAlert(Title : String!, Message : String!)  -> UIAlertController {

        let alertController : UIAlertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("User pressed ok function")

        }

        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame

        return alertController
      } */
    
    
    @IBAction func cancelPost(_ sender: Any) {
        
        print("Post cancelled")
    }
    
    @IBAction func createPost(_ sender: Any) {
    
        newPost.title = "trying with struct"
        var message = ""
        let title = projectTitle.text ?? ""
        let category = projectCategory.text ?? ""
        let description = projectDescription.text ?? ""
        let instructions = projectInstructions.text ?? ""
        let unit = projectUnit.text ?? ""
        let value = projectValue.text ?? ""
        let nameOfPoster = self.nameOfPoster
        var arrayOfImages: [UIImage] = []
        
        //TODO change to fetching url hardcoded image
        arrayOfImages.append(UIImage(named: "pic-1")!)
        
        newPost.nameOfPoster = "user name goes here"
        newPost.title = projectTitle.text ?? "temp title"
        newPost.category = projectCategory.text ?? ""
        newPost.description = projectDescription.text ?? ""
        newPost.instructions = projectInstructions.text ?? ""
        newPost.unit = projectUnit.text ?? ""
        newPost.value = projectValue.text ?? ""
        newPost.nameOfPoster = self.nameOfPoster
        newPost.postDate = "10/20/2020"
        newPost.arrayOfImages = arrayOfImages
        newPost.numLikes = "100"
        
        
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
        if unit.isEmpty && message.isEmpty {
            message = "Please add a project time value"
        }
        if value.isEmpty && message.isEmpty {
            message = "Please add project time units"
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
    }

    // TODO save into Firebase
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postCreatedSegueIdentifier",
        let nextVC = segue.destination as? SinglePostViewController {

            nextVC.singlePost = newPost
            nextVC.titleOfPost = self.projectTitle.text
            nextVC.caption = newPost.postCaption
            nextVC.posterName = newPost.nameOfPoster
            // change hard code
            nextVC.posterPhoto = UIImage(named: "pic-1")!
           // nextVC.posterPhoto = newPost.arrayOfImages.first!
        }
        
    }
    

}
