//
//  OrderTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoOrder: UIImageView!
    
    @IBOutlet weak var nameOrder: UILabel!
    
    @IBOutlet weak var countOrder: UILabel!
    @IBOutlet weak var priceOrder: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func minOrder(_ sender: UIButton) {
        
    }
    
    @IBAction func addOrder(_ sender: UIButton) {
        
    }
    
    @IBAction func removeOrder(_ sender: UIButton) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(data: orderProduc ) {
        photoOrder.image = data.photo
        nameOrder.text = data.name
        countOrder.text = "\(data.countOrder)"
        priceOrder.text =  "\(data.price)"
    }
    
}
