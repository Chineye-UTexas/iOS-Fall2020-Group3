//
//  UploadInstructionsViewController.swift
//  Made-App
//
//  Created by Chineye Emeghara on 11/17/20.
//

import UIKit

class UploadInstructionsViewController: UIViewController {
    
    var textViewContent = ""

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var instructionTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.saveButton.layer.cornerRadius = 5
        
    }


    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.textViewContent = self.instructionTextView.text
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "instructionToUploadSegue",
           let nextVC = segue.destination as? PostFormViewController {
            
            
            nextVC.projectInstructions
            
        
    }
    

}
