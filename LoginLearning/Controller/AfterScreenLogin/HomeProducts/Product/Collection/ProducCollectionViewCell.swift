//
//  ProducCollectionViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import SDWebImage

class ProducCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgProduc: UIView! {
        didSet {
            bgProduc.layer.cornerRadius = 10
            bgProduc.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var photoProduc: UIImageView!
    @IBOutlet weak var descProduc: UILabel!
    @IBOutlet weak var priceProduc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: ProducList) {
        descProduc.text  = data.title
        priceProduc.text = String("$ \(data.price)")
        let imgURl = URL(string: "\(data.image)")
        self.photoProduc.sd_setImage(with: imgURl)
       
    }

}
