//
//  SideTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class SideTableViewCell: UITableViewCell {

    @IBOutlet weak var ketSide: UILabel!
    @IBOutlet weak var imageSide: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(data: SideItem) {
        ketSide.text = data.ketItem
        imageSide.image = data.imageItem
       
    }
    
}
