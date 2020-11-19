//
//  SavedProjectsViewController.swift
//  Made-App
//
//  Created by Marissa Jenkins on 11/4/20.
//

import UIKit
import Firebase
import SDWebImage
import Foundation

class SavedProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var savedProjectsHeader: UILabel!
    
    var savedList: [Int: [String]] = [0: ["image1", "knitted sweater"], 1: ["image2", "melted crayons"], 2: ["image3", "balloon ring"], 3: ["image4", "birthday cake"]]
    var models = [Project]()
    var imageCounter = 0
    let storage = Storage.storage()
    var ref: DatabaseReference!
    var currItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
//        ref = Database.database().reference()
//        let id = uniqueID.split(separator: ".")
//
//        ref.child("users/\(id[0])/saved-projects").observeSingleEvent(of: .value, with: { (snapshot) in
//                for child in snapshot.children {
//                    // each child is a saved project
//                    let snap = child as! DataSnapshot
//                    let projectID = snap.key
//                    self.ref.child("posts/\(projectID)").observeSingleEvent(of: .value, with: { (innerSnapshot) in
//                      // Get user value
//                        let title = innerSnapshot.childSnapshot(forPath: "/project-title").value as! NSString
//                        let creationDate = innerSnapshot.childSnapshot(forPath: "/creationTime").value as! NSString
//                        let description = innerSnapshot.childSnapshot(forPath: "/description").value as! NSString
//                        let category = innerSnapshot.childSnapshot(forPath: "/category").value as! NSString
//                        let difficulty = innerSnapshot.childSnapshot(forPath: "/difficulty").value as! NSString
//                        let instructions = innerSnapshot.childSnapshot(forPath: "/instructions").value as! NSString
//                        let timeValue = innerSnapshot.childSnapshot(forPath: "/time").value as! NSString
//                        let images = innerSnapshot.childSnapshot(forPath: "/images").value as! NSArray
//                        let timeUnit = innerSnapshot.childSnapshot(forPath: "/timeUnit").value as! NSString
//
//                        self.models.append(Project(title: title, category: category, description: description, instructions: instructions, timeValue: timeValue, timeUnit: timeUnit, difficulty: difficulty, images: images, creationDate: creationDate, username: id[0] as NSString, reviews: [], firebaseProjectID: projectID))
//                      }) { (error) in
//                        print(error.localizedDescription)
//                    }
//                    print("after getting database saved projects")
//                }
//            })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
        if savedList.count == 0 {
            self.savedProjectsHeader.text = "No saved projects right now!"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedProjectsCell", for: indexPath) as! SavedProjectsCell
        
        let item = savedList[indexPath.row]
        cell.title.text = item![1]
        cell.photo.image = UIImage(named: item![0])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "savedProjectsToSingleViewSegue", sender: indexPath.row)
//    }
    
//    func getCellPosition() -> Int {
//        let indexPath = table.indexPathForSelectedRow
//        return indexPath!.row
//    }
//
//
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "savedProjectsToSingleViewSegue",
//        let nextVC = segue.destination as? SinglePostViewController
//     {
//         print("in explore feed segue to single view")
//         nextVC.delegate = self
//         let row = getCellPosition()
//         let model = models[row]
//         nextVC.singlePost = model
//         nextVC.titleOfPost = model.title as String
//         nextVC.caption = model.description as String
//         nextVC.postName = model.username as String
//         nextVC.photoURL = (model.images)[0] as? String
//         nextVC.firebasePostID = model.firebaseProjectID
//         nextVC.projectInstructions = model.instructions as String
//     }
//    }

}
