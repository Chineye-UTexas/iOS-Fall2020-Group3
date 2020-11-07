//
//  SinglePostViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 10/19/20.
//

import UIKit
import Firebase
import CoreData
import SDWebImage

var reviews: NSArray = []


class SinglePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    @IBOutlet weak var posterProfilePhoto: UIImageView!
    @IBOutlet weak var posterUsername: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    
    
    // sent from PostFormVC
    var singlePost = Project()
    var reviewList = [Review] ()
    var reviewCommentaryList = [NSMutableString] ()
    var firebasePostID = ""
    
    var postPhoto = UIImage()
    var photoURL: String!
    var postName: String!
    var arrayOfImages: [UIImage] = []
    var date: String!
    var titleOfPost: String!
    var likes: String!
    var caption: String!
    var comments: UITableView!
    var ref: DatabaseReference!

    var delegate: UIViewController!

    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // the data from the Project object we sent
        reviews = singlePost.reviews
        postTitle.text = String(singlePost.title)
        postCaption.text = String(singlePost.description)
        posterUsername.text = postName
        postImage.image = postPhoto
        postImage.backgroundColor = UIColor.systemPink
        let placeholderImage = UIImage(named: "image1") // make to a loading photo placeholder
        postImage.sd_setImage(with: URL(string: photoURL), placeholderImage: placeholderImage)
        numLikes.text = "10" // singlePost.numLikes -- we didn't talk about keeping likes, maybe number of times saved?
        dateOfPost.text = String(singlePost.creationDate)
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")
        self.ref.child("users/\(id[0])/projects/cc’d /reviews")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let key = snap.key
                        let value = snap.value
                        print("key = \(key)  value = \(value!)")
                    self.reviewCommentaryList.append(value as! NSMutableString)
                    }
            }
            )
        
        reviewTableView.reloadData()
                
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        // Do any additional setup after loading the view.
        print("viewing single post page")
    }
    
    
    /*
     Table View Functions
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewCommentaryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let comment = commentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTextCell", for: indexPath as IndexPath)
        let row = indexPath.row
        cell.textLabel?.numberOfLines = 6
        
        // todo chnage to review objects
        cell.textLabel?.text = String(reviewCommentaryList[row])
        
        return cell
    }
    
    /*
     Submitting a new review
     */
    
    // was going to implement as is, but if we leave it
    // as that one sentence, that won't capture all that
    // we're looking for in a review, so we need
    // another view for people to leave a review

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if segue.identifier == "singlePostToReviewSegue",
           let nextVC = segue.destination as? ReviewViewController {
            
            nextVC.postID = firebasePostID
            nextVC.postPhotoURL = photoURL
            nextVC.postTitle = postTitle.text!
        }
        
      //  otherVC.models = self.models
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
