//
//  SideMenuModel.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 25/08/2566 BE.
//

import Foundation
import UIKit

struct SideItem {
    let imageItem: UIImage
    let ketItem: String
}

var cellSide: [SideItem] = [
    SideItem(imageItem: UIImage(named: "Info Circle")!, ketItem: "Account Information"),
    SideItem(imageItem: UIImage(named: "Lock")!, ketItem: "Password"), SideItem(imageItem: UIImage(named: "Bag")!, ketItem: "Order"), SideItem(imageItem: UIImage(named: "Wallet")!, ketItem: "My Cards"), SideItem(imageItem: UIImage(named: "Heart")!, ketItem: "Wishlist"), SideItem(imageItem: UIImage(named: "Setting")!, ketItem: "Settings")
]
