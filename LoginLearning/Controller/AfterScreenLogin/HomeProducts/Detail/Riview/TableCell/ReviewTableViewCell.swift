//
//  ReviewTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var photoRiview: UIImageView! {
        didSet {
            photoRiview.layer.cornerRadius = photoRiview.frame.size.width / 2
            photoRiview.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameRiview: UILabel!
    
    @IBOutlet weak var timeRiview: UILabel!
    
    @IBOutlet weak var ratingRiview: UILabel!
    
    @IBOutlet weak var descRiview: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureRiview(data: Riview) {
        photoRiview.image = data.photo
        nameRiview.text = data.name
        timeRiview.text = data.date
        ratingRiview.text = "\(data.rating)"
        descRiview.text = data.desc
    }
    
}
