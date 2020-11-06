//
//  UserProfileViewController.swift
//  Made-App
//
//  Created by Marissa Jenkins on 10/21/20.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var userScreenName: UILabel!
    var postList = ["pic-1",
                    "pic-2",
                    "image1",
                    "image2",
                    "image3"]
    var imageCounter = 0
    
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name == %@", uniqueID)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [User]
            if let aUser = fetchedResults.first {
                userScreenName.text = "Creator " + aUser.screenName!
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileImageCell", for: indexPath) as! MadeImageCell
        
        cell.backgroundColor = UIColor.yellow
        let currImageName = postList[self.imageCounter]
        self.imageCounter += 1
        if self.imageCounter >= postList.count {
            self.imageCounter = 0
        }
        
        // set image 
        cell.image.image = UIImage(named: currImageName)
        
//        cell.mainImageView.image = images[indexPath.row]
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
