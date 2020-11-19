//
//  ExploreFeedViewController.swift
//  Made-App
//
//  Created by Megan Teo on 11/17/20.
//

import UIKit
import Firebase

class ExploreFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var ref = Database.database().reference()
    var models = [Project]()
    var currCategory = ""
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

        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        let id = uniqueID.split(separator: ".") // this is their email, but '.' are not allowed in the path
        print("in VIEW DID LOAD")
        print(currCategory)
        let postPath = self.ref.child("posts")
            .observeSingleEvent(of: .value, with: { (snapshot) in

                for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let key = snap.key
                        let value = snap.value
                        print("key = \(key)  value = \(value!)")
                        
                        category = snapshot.childSnapshot(forPath: "\(key)/category").value as! NSString
                        if(self.currCategory == category as String) {
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
                            print(images)
                            timeValue = snapshot.childSnapshot(forPath: "\(key)/time").value as! NSString
                            username = snapshot.childSnapshot(forPath: "\(key)/user").value as! NSString
                            timeUnit = snapshot.childSnapshot(forPath: "\(key)/timeUnit").value as! NSString
                            print(timeUnit)
                            
                            self.models.append(Project(title: title, category: category, description: description, instructions: instructions, timeValue: timeValue, timeUnit: timeUnit, difficulty: difficulty, images: images, creationDate: creationDate, username: username, reviews: [], firebaseProjectID: key))
                        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "exploreFeedToSingleViewSegue", sender: indexPath.row)
    }
    
    // check these values
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 + 140 + view.frame.size.width
    }
    
    func getCellPosition() -> Int {
        let indexPath = table.indexPathForSelectedRow
        return indexPath!.row
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "exploreFeedToSingleViewSegue",
           let nextVC = segue.destination as? SinglePostViewController
        {
            print("in explore feed segue to single view")
            nextVC.delegate = self
            let row = getCellPosition()
            let model = models[row]
            nextVC.singlePost = model
            nextVC.titleOfPost = model.title as String
            nextVC.caption = model.description as String
            nextVC.postName = model.username as String
            nextVC.photoURL = (model.images)[0] as? String
            nextVC.firebasePostID = model.firebaseProjectID
            nextVC.projectInstructions = model.instructions as String
        }
    }

}
