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
    
    @IBOutlet weak var nameCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
