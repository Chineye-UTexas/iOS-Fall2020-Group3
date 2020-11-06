//
//  SinglePostViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 10/19/20.
//

import UIKit
import Firebase
import CoreData

var commentList:[String] = []


class SinglePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var commentTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let comment = commentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTextCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.numberOfLines = 6
        cell.textLabel?.text = commentList[row]
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // add comment code
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // add comment code
//    }
    
    
   // var caption = ""
    //var models: [madePost] = [] //TODO update madepost struct
    var testPost = madePost(numLikes: 0, username: "", userProfilePicture: "", postTitle: "", projectTitle: "", projectReview: "")
    
    @IBOutlet weak var posterProfilePhoto: UIImageView!
    @IBOutlet weak var posterUsername: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    // sent from PostFormVC
    var singlePost = Post(title: "single" )
    
    var posterPhoto = UIImage()
    var posterName: String!
    var arrayOfImages: [UIImage] = []
    var date: String!
    var titleOfPost: String!
    var likes: String!
    var caption: String!
    var comments: UITableView!
    
    var delegate: UIViewController!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        commentTableView.reloadData()
        
        
        // fetch firebase here
        
        commentList = singlePost.arrayOfComments
        postTitle.text = singlePost.title
        postCaption.text = singlePost.postCaption
        posterUsername.text = posterName
        postImage.image = posterPhoto
        numLikes.text = singlePost.numLikes
        dateOfPost.text = singlePost.postDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
                
        //      //  var ref: DatabaseReference!
//       // ref = Database.database().reference(withPath: "posts")
//
//
//        //   let postRef = ref(withPath: "posts")
//           ref?.observeSingleEvent(of: .value, with:
//               { snapshot in
//                   if !snapshot.exists()
//                   {
//                       print("snapshot doesnt exist")
//                       return
//
//                   }
//                   print("snapshot exists")
//                   print(snapshot)
//
//                var dict = snapshot.value as? NSDictionary
//                //guard fetchedUsername =
//
//                self.posterUsername.text = dict?["userID"] as? String ?? "default username"
//                self.postCaption.text = dict?["caption"] as? String ?? "no caption"
//                self.dateOfPost.text = dict?["date"] as? String ?? "no date" //change to date-time format
//                self.numLikes.text = dict?["numLikes"] as? String ?? "0" + " likes"
//                self.postImage.image = dict?["imageURL"] as? UIImage ?? UIImage(named: "pic-1")
//
//               })
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
            
//        let post = ["caption" : "testing",
//            "date" : "",
//            "imageURL" : "",
//            "numLikes" : "",
//            "postID" : "001",
//            "userID" : ""
//          ]
        
        
    
        
        
        

        //testpost should be set
        
      //  let otherVC = delegate as! MadeFeedViewController
        //testPost = otherVC.models[1]
        
        //posterUsername.text = testPost.username //"@ira"
        //self.models = otherVC.models
        //var testPost = self.models[1]//"@ira"
        
      //  self.dismiss(animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }
    
    /*
     Submitting comment
     */

    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func submitCommentButton(_ sender: Any) {
        
        if(!(commentTextField.text!.isEmpty)){
            // testing adding comments to table
            commentList.append(commentTextField.text ?? "example comment")
            //print(commentList.first!)
            commentTableView.reloadData()
        }

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
