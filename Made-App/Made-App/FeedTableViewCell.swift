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
    
    func configure(with model: madePost) {
        self.likesLabel.text = "\(model.numLikes) Likes"
        self.usernameLabel.text = model.username
        self.userProfilePicture.image = UIImage(named: model.userProfilePicture)
        self.postImageView.image = UIImage(named: model.postTitle)
    }
    
}
