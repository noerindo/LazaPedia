//
//  ProfileViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class ProfileViewController: UIViewController {
    var profileMV = ProfileModelView()

    @IBOutlet weak var photoUser: UIImageView! {
        didSet {
            photoUser.layer.cornerRadius = photoUser.frame.size.width / 2
            photoUser.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarText()
        getDataProfile()
    }
    
    func getDataProfile() {
        profileMV.getProfile { [self] result in
            DispatchQueue.main.async {
                self.emailText.text = result?.email
                self.userNameText.text = result?.username
                self.nameText.text = result?.full_name
                let imgURl = URL(string: "\(result?.image_url ?? "")")
                self.photoUser.sd_setImage(with: imgURl)
            }
           
        } onError: { error in
            print("error")
        }

    }
    
    private func setupTabBarText() {
        let label2 = UILabel()
        label2.numberOfLines = 1
        label2.textAlignment = .center
        label2.text = "Profile"
        label2.font = UIFont(name: "inter-Medium", size: 11)
        label2.sizeToFit()
        
        tabBarItem.selectedImage = UIImage(view: label2)
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        updateVC.email = emailText.text!
        updateVC.userNamee = userNameText.text!
        updateVC.name = nameText.text!
        self.navigationController?.pushViewController(updateVC, animated: true)
    }
    

}
