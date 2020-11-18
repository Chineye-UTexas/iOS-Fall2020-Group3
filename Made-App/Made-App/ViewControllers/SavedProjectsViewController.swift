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
    var imageCounter = 0
    let storage = Storage.storage()
    var ref: DatabaseReference!
    
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
                    let value = snap.value as! NSDictionary
                    let images = value["images"] as! NSArray
                    let imageURL = images[0] as! String
                    print("key = \(projectID)  value = \(value)")
                    print("imageURL = \(imageURL)")
                    if !self.savedList.contains(imageURL) {
                        self.savedList.append(imageURL)
                    }
                    self.collectionView.reloadData()
                    print("after getting database saved projects")
                }
            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedProjectsCellIdentifier", for: indexPath) as! MadeImageCell
        
        // this could be cool customizable!
        cell.backgroundColor = UIColor.black
        
        let currImageName = savedList[self.imageCounter]
        self.imageCounter += 1
        if self.imageCounter >= savedList.count {
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
                cell.image.image = UIImage(data: data!)
              }
            }
        }
        
        return cell
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
