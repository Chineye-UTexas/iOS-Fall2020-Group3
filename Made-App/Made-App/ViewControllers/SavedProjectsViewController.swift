//
//  SavedProjectsViewController.swift
//  Made-App
//
//  Created by Marissa Jenkins on 11/4/20.
//

import UIKit
import Firebase

class SavedProjectsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var savedList = ["pic-1",
                    "pic-2",
                    "image1",
                    "image2",
                    "image3"]
    var imageCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        // Get a reference to the storage service using the default Firebase App
//        let storage = Storage.storage()
//
//        // Create a storage reference from our storage service
//        //let storageRef = storage.reference()
//        // This is equivalent to creating the full reference
//        let storagePath = "\(storage)/images/space.jpg"
//        var spaceRef = storage.reference(forURL: storagePath)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedProjectsCellIdentifier", for: indexPath) as! MadeImageCell
        
        cell.backgroundColor = UIColor.yellow
        let currImageName = savedList[self.imageCounter]
        self.imageCounter += 1
        if self.imageCounter >= savedList.count {
            self.imageCounter = 0
        }
        
        // set image
        cell.image.image = UIImage(named: currImageName)
        
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
