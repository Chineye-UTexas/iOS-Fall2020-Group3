//
//  FeedTableViewCell.swift
//  Made-App
//
//  Created by Megan Teo on 10/20/20.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectReview: UILabel!
    
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
    
    func configure(with model: Project) {
        self.usernameLabel.text = model.username as String
//        self.userProfilePicture.image = UIImage(named: model.userProfilePicture)
        self.postImageView.image = UIImage(named: model.images[0] as! String)
        self.projectTitle.text = model.title as String
        self.projectReview.text = model.description as String
    }
}
