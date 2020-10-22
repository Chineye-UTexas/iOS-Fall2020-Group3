//
//  SinglePostViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 10/19/20.
//

import UIKit
import Firebase

var commentList:[NSManagedObject] = []


class SinglePostViewController: UIViewController {
    
    var caption = ""
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var posterProfilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var delegate: UIViewController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func testCaption(_ sender: Any) {
        
        let otherVC = delegate as! PostFormViewController
        
        otherVC.caption = self.caption
        
        self.dismiss(animated: true, completion: nil
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
