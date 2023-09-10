//
//  SnackBar.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 02/09/2566 BE.
//

import Foundation
import SnackBar_swift

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
