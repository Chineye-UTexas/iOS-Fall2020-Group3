//
//  MadeFeedViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/20/20.
//

import UIKit

struct madePost {
    let numLikes: Int
    let username: String
    let userProfilePicture: String
    let postTitle: String
}

class MadeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    var models = [madePost]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self

        models.append(madePost(numLikes: 200, username: "@megan", userProfilePicture: "profilePic", postTitle: "image1"))
        models.append(madePost(numLikes: 200, username: "@ira", userProfilePicture: "profilePic", postTitle: "image2"))
        models.append(madePost(numLikes: 200, username: "@marissa", userProfilePicture: "profilePic", postTitle: "image3"))
        models.append(madePost(numLikes: 200, username: "@chineye", userProfilePicture: "profilePic", postTitle: "image4"))
        models.append(madePost(numLikes: 200, username: "@mike", userProfilePicture: "profilePic", postTitle: "image5"))
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
