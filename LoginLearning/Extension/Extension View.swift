//
//  Extension View.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 27/07/2566 BE.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow(color: UIColor, width: CGFloat, text: UITextField) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: text.frame.height + 10 , width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        }
}

class Alert {
    static func createAlertController(title: String, message: String) -> UIAlertController {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
             alert.dismiss(animated: true, completion: nil)
         }
         
         alert.addAction(okAction)
         
         return alert
     }
}



