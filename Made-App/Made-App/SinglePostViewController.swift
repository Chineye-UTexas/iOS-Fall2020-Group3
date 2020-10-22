//
//  SinglePostViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 10/19/20.
//

import UIKit
import Firebase
import CoreData

var commentList:[NSManagedObject] = []


class SinglePostViewController: UIViewController {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // add comment code
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // add comment code
//    }
    
    
    var caption = ""
    var models: [madePost] = []
    var testPost = madePost(numLikes: 0, username: "", userProfilePicture: "", postTitle: "")
    
    @IBOutlet weak var posterProfilePhoto: UIImageView!
    @IBOutlet weak var posterUsername: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var delegate: UIViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "posts")
        
        
        //   let postRef = ref(withPath: "posts")
           ref?.observeSingleEvent(of: .value, with:
               { snapshot in
                   if !snapshot.exists()
                   {
                       print("snapshot doesnt exist")
                       return
                       
                   }
                   print("snapshot exists")
                   print(snapshot)
                
                var dict = snapshot.value as? NSDictionary
                //guard fetchedUsername =
                
                self.posterUsername.text = dict?["userID"] as? String ?? "default username"
                self.postCaption.text = dict?["caption"] as? String ?? "no caption"
                self.dateOfPost.text = dict?["date"] as? String ?? "no date" //change to date-time format
                self.numLikes.text = dict?["numLikes"] as? String ?? "0" + " likes"
                self.postImage.image = dict?["imageURL"] as? UIImage ?? UIImage(named: "pic-1")
                
               })
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
            
        let post = ["caption" : "testing",
            "date" : "",
            "imageURL" : "",
            "numLikes" : "",
            "postID" : "001",
            "userID" : ""
          ]
        
        
    
        
        
        

        //testpost should be set
        
      //  let otherVC = delegate as! MadeFeedViewController
        //testPost = otherVC.models[1]
        
        //posterUsername.text = testPost.username //"@ira"
        //self.models = otherVC.models
        //var testPost = self.models[1]//"@ira"
        
      //  self.dismiss(animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//      //  otherVC.models = self.models
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
}
