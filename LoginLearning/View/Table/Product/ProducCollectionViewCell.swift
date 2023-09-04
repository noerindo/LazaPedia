//
//  ProducCollectionViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import SDWebImage

class ProducCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgProduc: UIView!
    @IBOutlet weak var photoProduc: UIImageView! {
        didSet {
            photoProduc.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var descProduc: UILabel!
    @IBOutlet weak var priceProduc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: ProducList) {
        descProduc.text  = data.name
        priceProduc.text = String("$ \(data.price)")
        let imgURl = URL(string: "\(data.image_url)")
        self.photoProduc.sd_setImage(with: imgURl)
       
    }

}
