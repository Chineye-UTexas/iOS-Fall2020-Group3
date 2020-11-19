//
//  UserProfileViewController.swift
//  Made-App
//
//  Created by Marissa Jenkins on 10/21/20.
//

import UIKit
import CoreData
import Firebase
import SDWebImage
import Foundation
import AVFoundation

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userBio: UILabel!
    
    var postImageList: [String] = []
    var imageCounter = 0
    let storage = Storage.storage()
    var ref: DatabaseReference!
    var photoBackgroundColor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        settingsReload()
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")

        reloadProfilePicture()

        print("before post stuff")
        self.ref.child("user-posts/\(id[0])").observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children {
                // each child is a project
                let snap = child as! DataSnapshot
                let projectID = snap.key
                let value = snap.value as! NSDictionary
                let images = value["images"] as! NSArray
                let imageURL = images[0] as! String
                print("key = \(projectID)  value = \(value)")
                print("imageURL = \(imageURL)")
                if !self.postImageList.contains(imageURL) {
                    self.postImageList.append(imageURL)
                }
            }
            print("after getting database user projects")
            self.imageCounter = 0
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        settingsReload()
        reloadProfilePicture()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImageCell", for: indexPath) as! MadeImageCell
        print("in the collection view cell maker")
        print(imageCounter)
        print(postImageList)
        
        // this could be cool customizable!
        // convert the string to UIColor
        cell.backgroundColor = UIColor.black
        
        let currImageName = postImageList[self.imageCounter]
        self.imageCounter += 1
        if self.imageCounter >= postImageList.count {
            self.imageCounter = 0
        }
        
        // set image
        if currImageName != "" {
            // Create a reference from a Google Cloud Storage URI
            let gsReference = storage.reference(forURL: currImageName)
            // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
            gsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
              } else {
                // Data for image path is returned
                DispatchQueue.main.async {
                    cell.image.image = UIImage(data: data!)
                    print("update image number : ")
                    print(self.imageCounter)
                }
                // cell.image.image = UIImage(data: data!)
              }
            }
        }
        
        return cell
    }
    
    func reloadProfilePicture() {
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")
        var profilePictureName = ""

        self.ref.child("users/\(id[0])/profilePicture").observeSingleEvent(of: .value, with: {
            (snapshot) in
            print(snapshot)
            profilePictureName = snapshot.value as! String
            // set image
            if profilePictureName != "" {
                // Create a reference from a Google Cloud Storage URI
                let gsReference = self.storage.reference(forURL: profilePictureName)
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                gsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                  } else {
                    // Data for image path is returned
                    self.profilePicture.image = UIImage(data: data!)
                  }
                }
            }
        })
    }
    
    func settingsReload() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name == %@", uniqueID)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [User]
            if let aUser = fetchedResults.first {
                self.photoBackgroundColor = aUser.photoBackgroundColor
                self.userScreenName.text = "Creator " + aUser.screenName!
                self.userBio.text = aUser.bio
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
