//
//  AdressTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class AdressTableViewCell: UITableViewCell {

    @IBOutlet weak var adressComplite: UILabel!
    @IBOutlet weak var namePhoneText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
}
