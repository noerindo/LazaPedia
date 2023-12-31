//
//  Extension View.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 27/07/2566 BE.
//

import UIKit


extension UIView {
    
    func addShadow(color: UIColor, width: CGFloat, text: UITextField) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: text.frame.height + 10 , width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        }
}

extension UIImage {
    // This method creates an image of a view
    convenience init?(view: UIView) {
        
        // Based on https://stackoverflow.com/a/41288197/1118398
        
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}

// membuat string dengan huruf pertama kapital
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    func formatDecimal() -> String {
        var text = self
        if self.hasSuffix(".0") {
            let start = self.index(self.endIndex, offsetBy: -2)
            let end = self.endIndex
            text.removeSubrange(start..<end)
        }
        return text
    }
    
    func dateReview(date: String) -> String {
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = formatter.date(from: date) {
            formatter.dateFormat = "d MMM, yyyy"
            return formatter.string(from: formattedDate)
        }
        return date
    }
}

extension Notification.Name {
    static var UpdateChart: Notification.Name {
        return .init("CartUpdated")
    }
    static var UpdateAdress: Notification.Name {
        return .init("AdressUpdte")
    }
    static var UpdateWishlist: Notification.Name {
        return .init("WishlistUpdate")
    }
    static var UpdateCard: Notification.Name {
        return .init("CardUpdate")
    }
}


