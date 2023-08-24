//
//  EditProfileViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 23/08/2566 BE.
//

import UIKit

protocol EditProfileViewControllerDelegate: AnyObject {
    func onProfileUpdated(updatedProfile: DataProfileUser)
}
class EditProfileViewController: UIViewController {
    private let imagePicker = UIImagePickerController()
    var media: Media?
    var email: String = ""
    var name: String = ""
    var userNamee: String = ""
    var photoOld: String = ""
    var profileMV = ProfileModelView()
    weak var delegate: EditProfileViewControllerDelegate?
    @IBOutlet weak var userName: UITextField! {
        didSet {
            userName.addShadow(color: .gray, width: 0.5, text: userName)
            userName.text = name
        }
    }
    
    @IBOutlet weak var emailUser: UITextField! {
    didSet {
        emailUser.addShadow(color: .gray, width: 0.5, text: emailUser)
        emailUser.text = email
       }
   }
    @IBOutlet weak var fullName: UITextField! {
        didSet {
            fullName.addShadow(color: .gray, width: 0.5, text: fullName)
            fullName.text = name
       }
   }
    @IBOutlet weak var photoProfile: UIImageView! {
        didSet {
            let imgURl = URL(string: "\(photoOld )")
            self.photoProfile.sd_setImage(with: imgURl)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    private func setupView() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        photoProfile.layer.cornerRadius = photoProfile.frame.height / 2
        photoProfile.clipsToBounds = true
        
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveActionBtn(_ sender: UIButton) {
        guard let userName = userName.text else {return}
        guard let fullName = fullName.text else {return}
        guard let email = emailUser.text else { return }
        if let image = photoProfile.image {
            media = Media(withImage: image, forKey: "image")
        }
        
        if userName != "" && fullName != "" && email != "" {
            profileMV.putProfile(fullName: fullName, username: userName, email: email, media: media) { result in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sukses", message: "Data sudah diUpadet", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                      DispatchQueue.main.async {
                          self?.navigationController?.popViewController(animated: true)
                      }
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } onError: { error in
                DispatchQueue.main.async {
                    SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                }
            }
            
        } else {
            SnackBarWarning.make(in: self.view, message: "Data update Belum Lengkap", duration: .lengthShort).show()
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoProfile.contentMode = .scaleToFill
            self.photoProfile.image = result
//            titleButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
