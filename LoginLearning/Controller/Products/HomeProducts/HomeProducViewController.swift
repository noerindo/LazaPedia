//
//  HomeProducViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 28/07/2566 BE.
//

import UIKit

class HomeProducViewController: UIViewController {
    
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Favorite"
        label2.font = UIFont(name: "inter", size: 11)
        label2.sizeToFit()
        
        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "colorBg")
//        tabBarItem.selectedImage = UIImage(view: label2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarText()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
