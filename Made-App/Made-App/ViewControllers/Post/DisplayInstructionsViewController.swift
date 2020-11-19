//
//  DisplayInstructionsViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 11/18/20.
//

import UIKit

class DisplayInstructionsViewController: UIViewController {

    
    @IBOutlet weak var instructionProjectTitle: UILabel!
    @IBOutlet weak var instructionTextView: UITextView!
    
    var projectInstructions = ""
    var projectTitle = ""
    var postID = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.instructionProjectTitle.text = self.projectTitle
        self.instructionTextView.text = (self.projectInstructions == "")
            ? "nothing here" : self.projectInstructions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
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
