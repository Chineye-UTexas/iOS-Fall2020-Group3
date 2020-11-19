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
    
    var delegate:UIViewController!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.saveButton.layer.cornerRadius = 5
        
    }


    @IBAction func saveButtonAction(_ sender: Any) {
        
        self.textViewContent = self.instructionTextView.text!
        
        let otherVC = delegate as! InstructionUpdate
        otherVC.onSaveInstructions(type: textViewContent)

        self.dismiss(animated: true, completion: nil)

        
    }
    
    
    // MARK: - Navigation

   //  In a storyboard-based application, you will often want to do a little //preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let nextVC = segue.destination as? PostFormViewController
//        {
//            nextVC.projectInstructions = self.textViewContent
//            //nextVC.instructionsButton.backgroundColor = UIColor.gray
//        }
//    }
}
