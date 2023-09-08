//
//  ProfileViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class ProfileViewController: UIViewController {
    let viewModel = ProfileVM()
    var linkPhoto: String = ""
    var idProfile: Int = 0
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
        displayUserProfileByUserdefault()
    }
    
    //func untuk menampilkan data user menggunakan api
    func fetchUserProfile() {
        viewModel.getProfile { result in
            DispatchQueue.main.async {
                self.displayUserProfile(result)
            }
        } onError: { error in
            print("error \(error)")
        }
    }
    
    func displayUserProfile(_ userProfile: DataProfileUser?) {
        if let userProfile = userProfile {
            DispatchQueue.main.async {
                // Mengisi IBOutlets dengan data profil pengguna
                
                self.emailText.text = userProfile.email
                self.userNameText.text = userProfile.username
                self.nameText.text = userProfile.full_name
                self.linkPhoto = "\(userProfile.image_url ?? "")"
                let imgURl = URL(string: "\(userProfile.image_url ?? "")")
                self.photoUser.sd_setImage(with: imgURl)
            }
        } else {
            // Failed to get user profile
            print("Failed to get user profile")
        }
    }
    
    func displayUserProfileByUserdefault() {
        DispatchQueue.main.async {
            if let data = UserDefaults.standard.object(forKey: "UserProfileDefault") as? Data,
               let profile = try? JSONDecoder().decode(ProfileUser.self, from: data) {
                self.modelProfile = profile.data
            }
            
            self.emailText.text = self.modelProfile?.email
            self.userNameText.text = self.modelProfile?.username
            self.nameText.text = self.modelProfile?.full_name
            self.linkPhoto = "\(self.modelProfile?.image_url ?? "")"
            let imgURl = URL(string: "\(self.modelProfile?.image_url ?? "")")
            self.photoUser.sd_setImage(with: imgURl)
        }
    }
    
//    func getDataProfile() {
//        viewModel.getProfile { [self] result in
//            DispatchQueue.main.async {
//                self.emailText.text = result?.email
//                self.userNameText.text = result?.username
//                self.nameText.text = result?.full_name
//                self.linkPhoto = "\(result?.image_url ?? "")"
//                let imgURl = URL(string: "\(result?.image_url ?? "")")
//                self.photoUser.sd_setImage(with: imgURl)
//                self.idProfile = result!.id
//            }
//
//        } onError: { error in
//            print("error")
//        }

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
        guard let email = emailText.text else {return}
        guard let userName = userNameText.text else {return}
        guard let name = nameText.text else {return}
        
        let updateAdress = DataProfileUser(
            id: idProfile, username: name, email: email, full_name: name, image_url: linkPhoto)
        let updateVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        updateVC.configure(data: updateAdress)
        self.navigationController?.pushViewController(updateVC, animated: true)
    }
    

}
