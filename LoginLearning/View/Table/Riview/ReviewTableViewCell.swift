//
//  ReviewTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import Cosmos

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var photoRiview: UIImageView! {
        didSet {
            photoRiview.layer.cornerRadius = photoRiview.frame.size.width / 2
            photoRiview.clipsToBounds = true
        }
    }
    @IBOutlet weak var starRating: CosmosView! {
        didSet {
            starRating.settings.fillMode = .precise
            starRating.settings.updateOnTouch = false
            starRating.settings.totalStars = 5
            starRating.settings.starMargin = 1
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
    func configureRiview(data: ReviewProduct) {
        let imgURl = URL(string: "\(data.image_url)")
        self.photoRiview.sd_setImage(with: imgURl)
        nameRiview.text = data.full_name
        timeRiview.text = data.created_at.dateReview(date: "\(data.created_at.dateReview)")
        ratingRiview.text = "\(data.rating)"
        descRiview.text = data.comment
        starRating.rating = data.rating
    }
    
}
