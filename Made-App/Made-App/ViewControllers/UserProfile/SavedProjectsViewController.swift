//
//  SavedProjectsViewController.swift
//  Made-App
//
//  Created by Marissa Jenkins on 11/4/20.
//

import UIKit
import Firebase
import SDWebImage
import Foundation

class SavedProjectsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var savedProjectsHeader: UILabel!
    
    var savedList: [String] = []
    var models = [Project]()
    var imageCounter = 0
    let storage = Storage.storage()
    var ref: DatabaseReference!
    var currItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")

        ref.child("users/\(id[0])/saved-projects").observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    // each child is a saved project
                    let snap = child as! DataSnapshot
                    let projectID = snap.key
//                    let value = snap.value as! NSDictionary
//                    let images = value["images"] as! NSArray
//                    let imageURL = images[0] as! String
//                    print("key = \(projectID)  value = \(value)")
//                    print("imageURL = \(imageURL)")
//                    if !self.savedList.contains(imageURL) {
//                        self.savedList.append(imageURL)
//                    }
                    self.ref.child("posts/\(projectID)").observeSingleEvent(of: .value, with: { (innerSnapshot) in
                      // Get user value
                        let title = innerSnapshot.childSnapshot(forPath: "/project-title").value as! NSString
                        let creationDate = innerSnapshot.childSnapshot(forPath: "/creationTime").value as! NSString
                        let description = innerSnapshot.childSnapshot(forPath: "/description").value as! NSString
                        let category = innerSnapshot.childSnapshot(forPath: "/category").value as! NSString
                        let difficulty = innerSnapshot.childSnapshot(forPath: "/difficulty").value as! NSString
                        let instructions = innerSnapshot.childSnapshot(forPath: "/instructions").value as! NSString
                        let timeValue = innerSnapshot.childSnapshot(forPath: "/time").value as! NSString
                        let images = innerSnapshot.childSnapshot(forPath: "/images").value as! NSArray
                        let timeUnit = innerSnapshot.childSnapshot(forPath: "/timeUnit").value as! NSString
                        
                        self.models.append(Project(title: title, category: category, description: description, instructions: instructions, timeValue: timeValue, timeUnit: timeUnit, difficulty: difficulty, images: images, creationDate: creationDate, username: id[0] as NSString, reviews: [], firebaseProjectID: projectID))
                      }) { (error) in
                        print(error.localizedDescription)
                    }
//                    let title = snapshot.childSnapshot(forPath: "\(projectID)/project-title").value as! NSString
//                    let creationDate = snapshot.childSnapshot(forPath: "\(projectID)/creationTime").value as! NSString
//                    let description = snapshot.childSnapshot(forPath: "\(projectID)/description").value as! NSString
//                    let category = snapshot.childSnapshot(forPath: "\(projectID)/category").value as! NSString
//                    let difficulty = snapshot.childSnapshot(forPath: "\(projectID)/difficulty").value as! NSString
//                    let instructions = snapshot.childSnapshot(forPath: "\(projectID)/instructions").value as! NSString
//                    let timeValue = snapshot.childSnapshot(forPath: "\(projectID)/time").value as! NSString
//                    let images = snapshot.childSnapshot(forPath: "\(projectID)/images").value as! NSArray
//                    let timeUnit = snapshot.childSnapshot(forPath: "\(projectID)/timeUnit").value as! NSString
//
//                    self.models.append(Project(title: title, category: category, description: description, instructions: instructions, timeValue: timeValue, timeUnit: timeUnit, difficulty: difficulty, images: images, creationDate: creationDate, username: id[0] as NSString, reviews: [], firebaseProjectID: projectID))
                    
                    print("after getting database saved projects")
                }
            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        if models.count == 0 {
            self.savedProjectsHeader.text = "No saved projects right now!"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedProjectsCellIdentifier", for: indexPath) as! MadeImageCell
        
        // this could be cool customizable!
        cell.backgroundColor = UIColor.black
        
        let model = models[indexPath.item]
        let currImageName = (model.images)[0] as! String
        
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
                cell.image.image = UIImage(data: data!)
              }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currItem = indexPath.item
        performSegue(withIdentifier: "savedProjectsToSingleViewSegue", sender: indexPath.row)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "savedProjectsToSingleViewSegue",
        let nextVC = segue.destination as? SinglePostViewController
     {
         print("in explore feed segue to single view")
         nextVC.delegate = self
         let model = models[currItem]
         nextVC.singlePost = model
         nextVC.titleOfPost = model.title as String
         nextVC.caption = model.description as String
         nextVC.postName = model.username as String
         nextVC.photoURL = (model.images)[0] as? String
         nextVC.firebasePostID = model.firebaseProjectID
         nextVC.projectInstructions = model.instructions as String
     }
    }

}
