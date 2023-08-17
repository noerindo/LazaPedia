//
//  SizeCollectionViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class SizeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sizeText: UILabel! {
        didSet {
            sizeText.font = UIFont(name: "Inter-SemiBold", size: 17)
        }
    }
    @IBOutlet weak var bgSize: UIView! {
        didSet {
            bgSize.layer.cornerRadius = 10
            bgSize.backgroundColor = UIColor(named: "colorBtn")
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
