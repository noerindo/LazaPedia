//
//  Extension View.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 27/07/2566 BE.
//

import UIKit
import SnackBar_swift


extension UIView {
    
    func addShadow(color: UIColor, width: CGFloat, text: UITextField) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: text.frame.height + 10 , width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        }
}

class SnackBarWarning: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .red
        style.textColor = .white
        return style
    }
}
class SnackBarSuccess: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .green
        style.textColor = .white
        return style
    }
}

// membuat string dengan huruf pertama kapital
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}




