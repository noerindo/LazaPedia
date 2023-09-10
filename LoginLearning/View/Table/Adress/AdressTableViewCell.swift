//
//  AdressTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class AdressTableViewCell: UITableViewCell {

    @IBOutlet weak var isPrimary: UIImageView! {
        didSet {
            isPrimary.isHidden = true
        }
    }
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 5
            bgView.layer.shadowColor = UIColor(named: "black")?.cgColor
            bgView.layer.shadowOpacity = 0.5
            bgView.layer.shadowOffset = .zero
            bgView.layer.shadowRadius = 5
        }
    }
    @IBOutlet weak var adressComplite: UILabel!
    @IBOutlet weak var namePhoneText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
    func configureAdress(data: DataAdress) {
        namePhoneText.text = "\(data.receiver_name) | \(data.phone_number)"
        adressComplite.text = "\(data.country) | \(data.city)"
        if data.is_primary == true {
            isPrimary.isHidden = false
        } else {
            isPrimary.isHidden = true
        }
    }
    
}
