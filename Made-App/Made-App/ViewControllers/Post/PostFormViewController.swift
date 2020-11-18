import UIKit
import Firebase
import CoreData
import AVFoundation
import AYPopupPickerView

let value: [Int] = Array(1...100)
let units = ["Minutes", "Hours", "Days", "Weeks", "Months", "Years"]

protocol InstructionUpdate {
    func onSaveInstructions(type: String)
}

class PostFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, InstructionUpdate {
    


    var imagePicker : UIImagePickerController = UIImagePickerController()
    
    var durationPopUpPickerView = AYPopupPickerView()

    @IBOutlet weak var projectDuration: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    
    @IBOutlet weak var projectTitle: UITextField!
    @IBOutlet weak var projectDescription: UITextField!
    var projectValue: String = ""
    var projectUnit: String = ""
    var projectInstructions = ""
    
    @IBOutlet weak var projectDifficulty: UISegmentedControl!
    @IBOutlet weak var photoLabel: UIButton!

    var projectImage: String = ""
    var difficulty: NSString = NSString()
    var newProject: Project?
    var screenName: String = ""
    var categorySelected: String = "Miscelleous"
    
    var postAutoID = ""
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.projectDuration.layer.cornerRadius = 5
        self.instructionsButton.layer.cornerRadius = 5
        
        print("here" + self.projectInstructions)
        
    }

    
    @IBAction func displayProjectDuration(_ sender: Any) {
        
        durationPopUpPickerView.pickerView.dataSource = self
        durationPopUpPickerView.pickerView.delegate = self
        
        durationPopUpPickerView.display(doneHandler: {
            let component0 = self.durationPopUpPickerView.pickerView.selectedRow(inComponent: 0)
           let component1 = self.durationPopUpPickerView.pickerView.selectedRow(inComponent: 1)
            
            

            self.projectUnit = units[component1]
            self.projectValue = String(Made_App.value[component0])
            
//            print("\(component0), \(component1)")
//            print("\(self.projectValue)    &   \(self.projectUnit)")
            
           })
    }
    
    @IBAction func displayPopupInstructionField(_ sender: Any) {
        
        
        
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        print("Post cancelled")
    }
    
    
    @IBAction func createPost(_ sender: Any) {
        
        var message = ""
        // let stringTitle = projectTitle.text ?? ""
        let title = NSString(string: projectTitle.text ?? "")
        let category = NSString(string: self.chosenCategoryLabel.text ?? "")
        let description = NSString(string: projectDescription.text ?? "")
        let instructions = NSString(string: projectInstructions)
        let timeUnit = NSString(string: projectUnit )
        let time = NSString(string: projectValue )
        let difficulty = self.difficulty
        let images: NSArray = [self.projectImage]
       // let reviews: [NSArray]
        let username = NSString(string: screenName)
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let datetime = NSString(string: formatter.string(from: now))
        print(datetime)
        
        self.newProject = Project(title: title, category: category,
                                  description: description, instructions: instructions,
                                  timeValue: time,
                                  timeUnit: timeUnit, difficulty: self.difficulty, images: images,
                                  creationDate: datetime, username: username, reviews: reviews as NSArray)
        
        if title.length == 0 {
            message = "Please add a project title"
        }
        if category.length == 0 && message.isEmpty {
            message = "Please add a project category"
        }
        if description.length == 0 && message.isEmpty {
            message = "Please add a project description"
        }
        if instructions.length == 0 && message.isEmpty {
            message = "Please add project instructions"
        }
        if timeUnit.length == 0 && message.isEmpty {
            message = "Please add a project time unit"
        }
        if time.length == 0 && message.isEmpty {
            message = "Please add project time value"
        }
        
        if !message.isEmpty {
            let alert = UIAlertController(
              title: "Post Creation Failed",
              message: message,
              preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // if we make it here , all data is good and needs to be saved to database
        ref = Database.database().reference()

        let id = uniqueID.split(separator: ".") // this is their email, but '.' are not allowed in the path
        
        let userPostPath = self.ref.child("user-posts/\(id[0])/")
        
        
        /*
         Add post
         */
        let postAutoID = userPostPath.childByAutoId()
        postAutoID.child("project-title").setValue(title)
        postAutoID.child("category").setValue(category)
        postAutoID.child("description").setValue(description)
        postAutoID.child("instructions").setValue(instructions)
        postAutoID.child("timeUnit").setValue(timeUnit)
        postAutoID.child("time").setValue(time)
        postAutoID.child("difficulty").setValue(difficulty)
        postAutoID.child("images").setValue(images)
        postAutoID.child("creationTime").setValue(datetime)
        
        guard let postAutoIDKey = postAutoID.key else { return }
        self.postAutoID = postAutoIDKey
        
        
        /*
         Add post entry to the masterlist of posts
         */
        let allPostsPath = self.ref.child("posts/\(String(describing: postAutoIDKey))/")
        
        allPostsPath.child("user").setValue(id[0])
        allPostsPath.child("project-title").setValue(title)
        allPostsPath.child("category").setValue(category)
        allPostsPath.child("description").setValue(description)
        allPostsPath.child("instructions").setValue(instructions)
        allPostsPath.child("timeUnit").setValue(timeUnit)
        allPostsPath.child("time").setValue(time)
        allPostsPath.child("difficulty").setValue(difficulty)
        allPostsPath.child("images").setValue(images)
        allPostsPath.child("creationTime").setValue(datetime)
        
        
        /*
         Create path for reviews
         */
        let postReviewPath: Void = self.ref.child("post-reviews/\(String(describing: postAutoIDKey))/").setValue("")
                
    }
    
    
    @IBAction func selectDifficulty(_ sender: Any) {
        switch projectDifficulty.selectedSegmentIndex {
        case 0:
            self.difficulty = "Easy"
        case 1:
            self.difficulty = "Medium"
        case 2:
            self.difficulty = "Hard"
        default:
            self.difficulty = "Easy"
        }
    }
    
    
    
    
    
    @IBOutlet weak var chosenCategoryLabel: UILabel!
    
    @IBAction func categoryTextBoxChanged(_ sender: Any) {
        let alert = UIAlertController(title: "Category",
                                           message: "Choose a category",
                                           preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Food",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Lifestyle",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Art",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Clothing",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Accessories",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Kids",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Science",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Pets",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Plants",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        alert.addAction(UIAlertAction(title: "Miscelleous",
                                           style: .default,
                                           handler: {
                                            // (action) in self.projectCategory.text = action.title!
                                            (action) in self.categorySelected = action.title!
                                            self.chosenCategoryLabel.text = action.title!
                                           }))
        
        present(alert, animated: true, completion: nil)
        //chosenCategoryLabel.text = self.categorySelected
    }
    
    
    
    /*
     Photo Handling
     */
    @IBAction func attachPhotos(_ sender: Any) {
        // to get access to the photos
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        // change words on screen to reflect photo attached
        // this animates and then goes away
        present(imagePicker, animated: true, completion: nil)
        // photoLabel.setTitle("Photo Attached Successfully", for: .normal)
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss the popover
        dismiss(animated: true, completion: nil)
        photoLabel.setTitle("Attach a Photo", for: .normal)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storageRef = storage.reference()
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let imageName = imageURL.lastPathComponent ?? "image"

        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(imageName)")

        // Upload the file to the path "images/\(imageName)"
        let uploadTask = imageRef.putFile(from: imageURL as URL, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                self.photoLabel.setTitle("Attach a Photo", for: .normal)
                print("photo did not save")
                return
          }
            print("photo saved")
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("could not get URL: \(String(describing: error))")
                    return
                }
                print("photo url:")
                print(downloadURL.absoluteString)
                self.projectImage = downloadURL.absoluteString
            }
        }
        picker.dismiss(animated: true, completion: {
            self.photoLabel.setTitle("Photo Attached Successfully", for: .normal)
        })
    }
    
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "postCreatedSegueIdentifier",
        let nextVC = segue.destination as? SinglePostViewController {

            nextVC.singlePost = self.newProject!
            nextVC.titleOfPost = self.projectTitle.text
            nextVC.caption = self.projectDescription.text
            nextVC.postName = self.screenName
            nextVC.photoURL = self.projectImage
            nextVC.firebasePostID = self.postAutoID
            nextVC.projectInstructions = self.projectInstructions
            
        } else if segue.identifier == "uploadToInstructionSegue",
                  let nextVC = segue.destination as? UploadInstructionsViewController {
            nextVC.delegate = self
        }
    }
    
    func onSaveInstructions(type: String) {
        
        self.projectInstructions = type
        print(self.projectInstructions)
    }
}


/*
 PickerView
 */
extension PostFormViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return Made_App.value.count
        } else if component == 1 {
            return units.count
        }
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if component == 0 {
            return "\(Made_App.value[row])"
        } else {
            return units[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        let time = pickerView.selectedRow(inComponent: 0)
        let unit = pickerView.selectedRow(inComponent: 1)
       
        
    }
}
