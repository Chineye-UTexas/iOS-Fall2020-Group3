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
    @IBOutlet weak var postCaption: UILabel!
    
    
    // sent from PostFormVC
    var singlePost = Project()
    var reviewList = [Review] ()
    var reviewCommentaryList = [NSMutableString] ()
    var firebasePostID = ""
    var reviews: Array<DataSnapshot> = []
    
    var projectInstructions = ""
    
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
    let storage = Storage.storage()

    var delegate: UIViewController!

    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")
        var profilePictureName = ""
        
        
        let postTree: Void = ref.child("posts").child(self.firebasePostID).observeSingleEvent(of: .value, with:
            { (snapshot) in
//            print(snapshot)
                
              //  var test = snapshot.value as! NSArray
              //  print(snapshot.value as Any)
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                
              //  var temp = postTree.child("project-title") as? NSMutableString
             //   print(title)
//                if let postingUser = snap.value?["user"] as? String ?? "test" {
//                    print("here")
//                }
            
//           let postingUser = snapshot.value["user"] as? String
//                print(postingUser)
//
//            if let description = snapshot.value["description"] as? String {
//                print(description)
//            }
//
//            if let imageURL = snapshot.value["images"] as? NSArray {
//                print(imageURL.count)
//            }
//
//            if let projectTime = snapshot.value["time"] as? String {
//                print(projectTime)
//            }
//
//            if let projectInstructions = snapshot.value["instructions"] as? String {
//                print(projectInstructions)
//            }
                                    
            }
        )
        { (error) in
            print(error.localizedDescription)
        }
    

        
//        self.projectInstructions = ref.child("posts/\(firebasePostID)/instructions/").value
        
        //self.projectInstructions = NSMutableString(self.projectInstructions.text)
        

        /*
         Profile picture
         */
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
                    self.posterProfilePhoto.image = UIImage(data: data!)
                  }
                }
            }
        })
        
        
        
        // the data from the Project object we sent
        reviews = singlePost.reviews as! Array<DataSnapshot>
        postTitle.text = titleOfPost // String(singlePost.title)
        postCaption.text = caption // String(singlePost.description)
        posterUsername.text = postName
        postImage.image = postPhoto
        postImage.backgroundColor = UIColor.systemPink
        let placeholderImage = postPhoto
        // make to a loading photo placeholder
        if photoURL != nil && !photoURL.isEmpty {
            print("photoURL not empty")
        postImage.sd_setImage(with: URL(string: photoURL), placeholderImage: placeholderImage)
        }
        dateOfPost.text = date // String(singlePost.creationDate)
       
        self.ref.child("users/\(id[0])/projects/\(String(describing: titleOfPost))/reviews")
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let key = snap.key
                        let value = snap.value
                        print("key = \(key)  value = \(value!)")
                    self.reviewCommentaryList.append(value as! NSMutableString)
                    }
            })
        reviewTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        posterProfilePhoto.layer.masksToBounds = true
        posterProfilePhoto.layer.cornerRadius = posterProfilePhoto.bounds.width / 2
        
    }
    
    
    /*
     Table View Funcoverride tions
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewCommentaryList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            nextVC.postPhotoURL = "https://firebasestorage.googleapis.com/v0/b/made-ios.appspot.com/o/images%2FC70801A6-8E87-4D4D-AED2-C881F4065437.jpeg?alt=media&token=daa27db3-ac81-473d-9fd3-d577651bf315" //photoURL
            nextVC.postTitle = postTitle.text!
        }
        else if segue.identifier == "displayInstructionsSegue",
            let nextVC = segue.destination as? DisplayInstructionsViewController
        {
            nextVC.projectTitle = self.titleOfPost
            nextVC.projectInstructions = self.projectInstructions
            
        }
    }
    
}