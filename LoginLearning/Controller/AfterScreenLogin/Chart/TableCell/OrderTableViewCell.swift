//
//  OrderTableViewCell.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

protocol OrderTableDelegate: AnyObject {
    func deleteOrder(cell: OrderTableViewCell)
//    func updateViewText(cell: OrderTableViewCell)
    func plusCountProduct(cell: OrderTableViewCell, completion: @escaping (Int) -> Void)
    func minCountProduct(cell: OrderTableViewCell)
}

class OrderTableViewCell: UITableViewCell {
    
    weak var delegate: OrderTableDelegate?
    
    @IBOutlet weak var photoOrder: UIImageView! {
        didSet {
            photoOrder.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var nameOrder: UILabel!
    
    @IBOutlet weak var countOrder: UILabel!
    @IBOutlet weak var priceOrder: UILabel!
    
    @IBOutlet weak var sizeProduct: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func minOrder(_ sender: UIButton) {
        self.delegate?.minCountProduct(cell: self)
        
        
    }
    
    @IBAction func addOrder(_ sender: UIButton) {
        self.delegate?.plusCountProduct(cell: self, completion: { result in
            self.countOrder.text = "\(result)"
        })
    }
    
    @IBAction func removeOrder(_ sender: UIButton) {
        self.delegate?.deleteOrder(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(data: ProductChart ) {
        let imgURl = URL(string: "\(data.image_url)")
        self.photoOrder.sd_setImage(with: imgURl)
        nameOrder.text = data.product_name
        countOrder.text = "\(data.quantity)"
        priceOrder.text =  "\(data.price)"
        sizeProduct.text = "Size: \(data.size)"
    }
    
}
