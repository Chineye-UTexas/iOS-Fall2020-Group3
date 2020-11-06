//
//  MadeFeedViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/20/20.
//

import UIKit
import Firebase

struct madePost {
    let numLikes: Int
    let username: String
    let userProfilePicture: String
    let postTitle: String
    let projectTitle: String
    let projectReview: String
}


class MadeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var ref = Database.database().reference()
    
    
    @IBOutlet weak var table: UITableView!
    var models = [madePost]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self

        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        models.append(madePost(numLikes: 200, username: "@megan", userProfilePicture: "profilePic2", postTitle: "image1", projectTitle: "Knit Cardigan", projectReview: "Fun and easy for beginners!"))
        models.append(madePost(numLikes: 200, username: "@ira", userProfilePicture: "profilePic2", postTitle: "image2", projectTitle: "DIY Crayon Canvas", projectReview: "Fun and easy for beginners!"))
        models.append(madePost(numLikes: 200, username: "@marissa", userProfilePicture: "profilePic2", postTitle: "image3", projectTitle: "Colorful Balloon Arch", projectReview: "Fun and easy for beginners!"))
        models.append(madePost(numLikes: 200, username: "@chineye", userProfilePicture: "profilePic2", postTitle: "image4", projectTitle: "Festive Celebration Cake", projectReview: "Fun and easy for beginners!"))
        models.append(madePost(numLikes: 200, username: "@mike", userProfilePicture: "profilePic2", postTitle: "image5", projectTitle: "Candles from Crayons", projectReview: "Fun and easy for beginners!"))
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // check these values
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 + 140 + view.frame.size.width
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "SinglePostSegueIdentifier",
//           let nextVC = segue.destination as? SinglePostViewController
//        {
//            nextVC.delegate = self
//            self.models[1] = nextVC.testPost //testing data being moved properly
////            models = nextVC.models
////            nextVC.testPost = models[0]
//        }
//    }
}
