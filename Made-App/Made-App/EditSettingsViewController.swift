//
//  EditSettingsViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/19/20.
//

import UIKit

class EditSettingsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    var name = ""
    var username = ""
    var bio = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.text = name
        usernameTextField.text = username
        passwordTextField.text = password
        bioTextField.text = bio
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        // save values to core data storage of user
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
