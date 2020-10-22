//
//  UserProfileViewController.swift
//  Made-App
//  Course: CS371L
//  Group 3
//
//  Created by Marissa Jenkins on 10/21/20.
//

import UIKit
import CoreData

class UserProfileViewController: UIViewController {

    @IBOutlet weak var userScreenName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "unique == %@", uniqueID)
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as! [User]
            if let aUser = fetchedResults.first {
                userScreenName.text = "Creator " + aUser.screenName!
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // to clean up the core data later we should delete the old info
    // created while in the set up process
    // container.viewContext.delete(user)
    // saveContext()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
