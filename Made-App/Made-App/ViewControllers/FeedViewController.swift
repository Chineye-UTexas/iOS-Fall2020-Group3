//
//  FeedViewController.swift
//  Made-App
//
//  Created by Megan Teo on 10/19/20.
//

import UIKit

class FeedViewController: UITableViewController {

    var images = [UIImage(imageLiteralResourceName: "image1"), UIImage(imageLiteralResourceName: "image2"), UIImage(imageLiteralResourceName: "image3"), UIImage(imageLiteralResourceName: "image4"), UIImage(imageLiteralResourceName: "image5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(ImageViewCell.self, forCellReuseIdentifier: "ImageViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewCell") as! ImageViewCell
        
        cell.mainImageView.image = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = images[indexPath.row]
        let imageCrop = currentImage.getCropRatio()
        return tableView.frame.width / imageCrop
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

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}
