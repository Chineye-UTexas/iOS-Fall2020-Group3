//
//  ProfilePicViewController.swift
//  Made-App
//
//  Created by Megan Teo on 11/6/20.
//

import UIKit
import AVFoundation
import Firebase

class ProfilePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    let picker = UIImagePickerController()
    var delegate: UIViewController!
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func libraryButtonPressed(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) {
                    accessGranted in
                    guard accessGranted == true else { return }
            }
            case .authorized:
                break
            default:
                print("Access denied")
                return
        }
        
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
        
            present(picker, animated: true, completion: nil)
        } else {
            // if no rear camera is available, pop up an alert
            let alertVC = UIAlertController(
                title: "No camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
        }
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
            }
        }

        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".") // this is their email, but '.' are not allowed in the path
        self.ref.child("users/\(id[0])/profilePicture/").setValue(databasePath)
        
        picker.dismiss(animated: true, completion: nil)
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
