//
//  FeedTableViewCell.swift
//  Made-App
//
//  Created by Megan Teo on 10/20/20.
//

import UIKit
import Firebase
import Foundation

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectReview: UILabel!
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    static let identifier = "FeedTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // provides spacing around the table cell
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func configure(with model: Project) {
        self.usernameLabel.text = model.username as String
        ref = Database.database().reference()
        let id = model.username
        print(id)
        var profilePictureName = ""

        self.ref.child("users/\(id)/profilePicture").observeSingleEvent(of: .value, with: {
            (snapshot) in
            print(snapshot)
            profilePictureName = snapshot.value as! String
            // set image
            if profilePictureName != "" {
                // Create a reference from a Google Cloud Storage URI
                let gsReference = self.storage.reference(forURL: profilePictureName)
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                gsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                  } else {
                    // Data for image path is returned
                    self.userProfilePicture.image = UIImage(data: data!)
                  }
                }
            }
        })
        // set image
        if model.images[0] as! String != "" {
            // Create a reference from a Google Cloud Storage URI
            let gsReference = storage.reference(forURL: model.images[0] as! String)
            // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
            gsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
              } else {
                // Data for image path is returned
                self.postImageView.image = UIImage(data: data!)
              }
            }
        }
        self.projectTitle.text = model.title as String
        self.projectReview.text = model.description as String
    }
}
