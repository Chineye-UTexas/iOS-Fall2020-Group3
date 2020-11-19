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

var reviews: [NSString] = []


class SinglePostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    @IBOutlet weak var posterProfilePhoto: UIImageView!
    @IBOutlet weak var posterUsername: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    
    @IBOutlet weak var addReviewButton: UIButton!
    
    // sent from PostFormVC
    var singlePost = Project()
    var reviewList = [Review] ()
    var reviewCommentaryList = [NSString] ()
    var firebasePostID = ""
    var reviews: Array<DataSnapshot> = []
    
    var projectInstructions = ""
    var comments: Array<DataSnapshot> = []
    let kSectionComments = 2
    let kSectionSend = 1
    let kSectionPost = 0
    
    var postPhoto = UIImage()
    var photoURL: String!
    var postName: String!
    var arrayOfImages: [UIImage] = []
    var date: String!
    var titleOfPost: String!
    var likes: String!
    var caption: String!
    var ref: DatabaseReference!
    let storage = Storage.storage()

    var delegate: UIViewController!

    @IBOutlet weak var reviewTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")
        var profilePictureName = ""
        
        
        let postTree = ref.child("posts").child(self.firebasePostID).observeSingleEvent(of: .value, with:
            { (snapshot) in
//            print(snapshot)
                
                /*
                 Retrieve Post attributes
                 */
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                
                let projTitle = postDict["project-title"] as? NSString
                self.postTitle.text = projTitle as String?
                
                let imagesArray = postDict["images"] as? NSMutableArray
                // make to a loading photo placeholder
                let placeholderImage = UIImage(named: "madeLogo")
                self.postImage.backgroundColor = UIColor.systemYellow
                if imagesArray != nil && imagesArray![0] as! NSString != "" {
                    print("photoURL not empty")
                    self.postImage.sd_setImage(with: URL(string: imagesArray![0] as! String), placeholderImage: placeholderImage)
                }
                
                
                let category = postDict["category"] as? NSString
                
                let username = postDict["user"] as? NSMutableString
                self.posterUsername.text = username as String?
                
                let time = postDict["time"] as? NSString
                
                let timeUnit = postDict["timeUnit"] as? NSString
                
                let difficulty = postDict["difficulty"] as! NSString
                
                let instructions = postDict["instructions"] as! NSString
                self.projectInstructions = instructions as String
                
                let creationTime = postDict["creationTime"] as! NSMutableString
                self.dateOfPost.text = creationTime as String
                
                let description = postDict["description"] as! NSString
                self.postCaption.text = description as String
                                
            }
        )
        { (error) in
            print(error.localizedDescription)
        }

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
    
        
        /*
         Retrieve the reviews
         */
        
        ref = Database.database().reference()
        
        let postRef = ref.child("post-reviews/\(self.firebasePostID)/")
        
        reviewCommentaryList.removeAll()
        // [START child_event_listener]
        // Listen for new comments in the Firebase database
        postRef.observe(.childAdded, with: { (snapshot) -> Void in
            self.reviewCommentaryList.append((snapshot.value as? NSString)!)
            self.reviewTableView.reloadData()
        })

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        posterProfilePhoto.layer.masksToBounds = true
        posterProfilePhoto.layer.cornerRadius = posterProfilePhoto.bounds.width / 2
    
        
        ref = Database.database().reference()
        
        let postRef = ref.child("post-reviews/\(self.firebasePostID)/")
        

        let refReview = postRef.observe(DataEventType.value, with:
            { (snapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                
                postDict.forEach{
                    
                    print($0.value as? NSString)
                    self.reviewCommentaryList.append(($0.value as? NSString)!)
                    
                }
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        reviewTableView.reloadData()

    }
    
    
    @IBAction func addReview(_ sender: Any) {
        
        /*
         Alert
         */
        let alertController = UIAlertController(title: "Add a Short Review", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Review Here"
            }
        
        /*
         Save comment
         */
            let saveAction = UIAlertAction(title: "Save Review", style: .default, handler: { alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                let reviewRef = self.ref.child("post-reviews/\(self.firebasePostID)/")

                reviewRef.childByAutoId().setValue(firstTextField.text)
                //self.reviewTableView.reloadData()

            })
        
        /*
         Cancel comment
         */
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
//        if segue.identifier == "singlePostToReviewSegue",
//           let nextVC = segue.destination as? ReviewViewController {
//
//            nextVC.postID = firebasePostID
//            nextVC.postPhotoURL = "https://firebasestorage.googleapis.com/v0/b/made-ios.appspot.com/o/images%2FC70801A6-8E87-4D4D-AED2-C881F4065437.jpeg?alt=media&token=daa27db3-ac81-473d-9fd3-d577651bf315" //photoURL
//            nextVC.postTitle = postTitle.text!
//        }
//        else
        if segue.identifier == "displayInstructionsSegue",
            let nextVC = segue.destination as? DisplayInstructionsViewController
        {
            nextVC.postID = self.firebasePostID
            nextVC.projectTitle = self.titleOfPost
            nextVC.projectInstructions = self.projectInstructions
            
        }
    }
    
}
