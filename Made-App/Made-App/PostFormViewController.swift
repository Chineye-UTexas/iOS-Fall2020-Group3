//
//  PostFormViewController.swift
//  Made-App
//
//  Created by Ira Dhar Gulati on 10/21/20.
//

import UIKit
import Firebase

class PostFormViewController: UIViewController {

    let post = Post(postID: "", postImageURL: "",
    postCaption: "testing caption", postDate: "")
  //  var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //testing saving a post 
       // ref = Database.database().reference(withPath: "post")
        
       // childRef = self.ref.child("caption")
        
        // "testing caption"
       // print(childRef);
        
       // let testPost = post
       // let postRef = self.ref.child(post.caption)

        //key = caption [text]
        //postRef.setValue(testPost)
        
//        ref.observe(.value, with: { snapshot in
//          print(snapshot.value as Any)})
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PostSegueIdentifier",
            let nextVC = segue.destination as? SinglePostViewController
        {
            nextVC.delegate = self
           // caption = nextVC.captionLabel.text
            print("inside single post VC")
           // print(caption)

        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
