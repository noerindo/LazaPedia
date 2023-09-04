//
//  CollectionViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var viewBg: UIView! {
        didSet {
            viewBg.layer.cornerRadius = 10
            viewBg.backgroundColor = UIColor(named: "colorBtn")
        }
    }
    
    @IBOutlet weak var photoBrand: UIImageView! {
        didSet{
            photoBrand.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var nameBrand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(data: Brand) {
        nameBrand.text = data.name
        let imgURL = URL(string: "\(data.logo_url)")
        self.photoBrand.sd_setImage(with: imgURL)
    }

}
