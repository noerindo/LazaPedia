//
//  ProfileViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class ProfileViewController: UIViewController {
    var modelProfile : DataProfileUser?
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
        DispatchQueue.main.async { [self] in
            guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
            guard let imageUrl = dataUser.image_url else {
                photoUser.image = UIImage(systemName: "person.circle.fill")
                return
            }
            
            emailText.text = dataUser.email
            userNameText.text = dataUser.username
            nameText.text = dataUser.full_name
            let imgURl = URL(string: "\(imageUrl)")
            photoUser.sd_setImage(with: imgURl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataProfile()
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
        guard let dataUser = KeychainManager.shared.getProfileFromKeychain() else {return}
        
        let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        updateVC.configure(data: dataUser)
        self.navigationController?.pushViewController(updateVC, animated: true)
    }
    

}
