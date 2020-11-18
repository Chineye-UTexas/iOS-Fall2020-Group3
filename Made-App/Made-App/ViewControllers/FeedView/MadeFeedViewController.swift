//
//  MadeFeedViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/20/20.
//

import UIKit
import Firebase

class MadeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var ref = Database.database().reference()
    
    @IBOutlet weak var table: UITableView!
    var models = [Project]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(FeedTableViewCell.nib(), forCellReuseIdentifier: FeedTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        var title = NSString()
        var category = NSString()
        var description = NSString()
        var instructions = NSString()
        var timeValue = NSString()
        var timeUnit = NSString()
        var difficulty = NSString()
        var images: NSArray = []
        var creationDate = NSString()
        var username = NSString()
        var reviews: NSArray = []

        // gather post data and append
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".") // this is their email, but '.' are not allowed in the path
        
        let postPath = self.ref.child("posts")
            .observeSingleEvent(of: .value, with: { (snapshot) in

                for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let key = snap.key
                        let value = snap.value
                        print("key = \(key)  value = \(value!)")
                    
                        title = snapshot.childSnapshot(forPath: "\(key)/project-title").value as! NSString
                        print(title)
                        creationDate = snapshot.childSnapshot(forPath: "\(key)/creationTime").value as! NSString
                        print(creationDate)
                        description = snapshot.childSnapshot(forPath: "\(key)/description").value as! NSString
                        print(description)
                        category = snapshot.childSnapshot(forPath: "\(key)/category").value as! NSString
                        print(category)
                        difficulty = snapshot.childSnapshot(forPath: "\(key)/difficulty").value as! NSString
                        print(difficulty)
                        instructions = snapshot.childSnapshot(forPath: "\(key)/instructions").value as! NSString
                        print(instructions)
                        images = snapshot.childSnapshot(forPath: "\(key)/images").value as! NSArray
                        timeValue = snapshot.childSnapshot(forPath: "\(key)/time").value as! NSString
                        username = snapshot.childSnapshot(forPath: "\(key)/user").value as! NSString
                        print(images)
                        timeUnit = snapshot.childSnapshot(forPath: "\(key)/timeUnit").value as! NSString
                        print(timeUnit)
                        
                        //self.models.append(currPost)
                    self.models.append(Project(title: title, category: category, description: description, instructions: instructions, timeValue: timeValue, timeUnit: timeUnit, difficulty: difficulty, images: images, creationDate: creationDate, username: username, reviews: ["ok"]))
                   
                }
                self.table.reloadData()
            })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
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
