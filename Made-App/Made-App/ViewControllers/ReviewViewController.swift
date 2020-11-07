//
//  ReviewViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 11/6/20.
//

import UIKit
import Firebase
import CoreData

class ReviewViewController: UIViewController {

    @IBOutlet weak var submitReviewButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var singleProjectPost_FirebaseID = 0
    var rating = 0
    var reviewText = String()
    var reviewList = [Review]()
    
    var postID = ""
    var postPhotoURL = ""
    var ref: DatabaseReference!
    var postTitle = "z"
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func difficultySlider(_ sender: Any) {
        
        self.rating = Int(ratingSlider.value)
        print("\(self.rating)")
        
    }
    
    @IBAction func submitButtonPressed(_ sender: Any)
    {
        let projTitle = postTitle
        
        print(projTitle)
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".")
               // todo chnage post title to post idm, to prevent duplicates
        let snapshotReviewList = self.ref.child("users/\(id[0])/projects/\(projTitle)/reviews")
        //let snapshotProject =
    
        ref.observe(.value, with: {
            (snapshot: DataSnapshot!) in
            print("i have the snapshot")
            print(snapshot.childrenCount)
            
            //counting num children
        })
        
        
        
        if (reviewTextView.hasText)
        {
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let datetime = NSString(string: formatter.string(from: now))

            reviewText = reviewTextView.text
            rating = Int(ratingSlider.value)
            
            var newReview = Review(commentary: reviewText as NSString, images: NSArray(object: [UIImage].self), creationDate: datetime, rating: NSNumber(value: rating))
            
            reviewList.append(newReview)
            
            snapshotReviewList.childByAutoId().setValue(reviewTextView.text)
            
        } else {
            
            // create the alert
            let alert = UIAlertController(title: "Please leave text!", message: "Please enter test for your review", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
            alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
            print("review submit button has been presseds")
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "reviewToSinglePostViewSegue",
        let nextVC = segue.destination as? SinglePostViewController {
        
            nextVC.reviewList = self.reviewList
            nextVC.firebasePostID = postID
            nextVC.photoURL = postPhotoURL
        }
    }

}
