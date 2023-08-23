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
        border.frame = CGRect(x: 0, y: text.frame.height + 15 , width: self.frame.size.width, height: width)
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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let formattedDate = formatter.date(from: date) {
            formatter.dateFormat = "d MMM, yyyy"
            return formatter.string(from: formattedDate)
        }
        return date
    }
    
}

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "Image_\(Date.now).jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}




