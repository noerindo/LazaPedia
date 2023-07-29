//
//  SignUpViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import UIKit

class SignUpViewController: UIViewController {
    private let userViewModel = UserViewModel()
    

    @IBOutlet weak var firstNameText: UITextField! {
        didSet {
            firstNameText.addShadow(color: .gray, width: 0.5, text: firstNameText)
            firstNameText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var lastNameText: UITextField! {
        didSet {
            lastNameText.addShadow(color: .gray, width: 0.5, text: lastNameText)
            lastNameText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var userNameText: UITextField! {
        didSet {
            userNameText.addShadow(color: .gray, width: 0.5, text: userNameText)
            userNameText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var passwordText: UITextField! {
        didSet {
           passwordText.addShadow(color: .gray, width: 0.5, text: passwordText)
            passwordText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var emailText: UITextField! {
        didSet {
            emailText.addShadow(color: .gray, width: 0.5, text: emailText)
            emailText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    @IBOutlet weak var phoneText: UITextField! {
        didSet {
            phoneText.addShadow(color: .gray, width: 0.5, text: firstNameText)
            phoneText.font = UIFont(name: "Inter-Medium", size: 15)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInActionBtn(_ sender: UIButton) {
        guard let username = userNameText.text else { return}
        guard let pass = passwordText.text else { return}
        if firstNameText.text != nil && lastNameText.text != nil && userNameText.text != nil && passwordText.text != nil && emailText.text != nil && phoneText.text != nil {
            self.userViewModel.loginDefault(isLogin: true, userName: username, pass: pass)
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        } else {
            self.present(Alert.createAlertController(title: "Warning", message: "data belum lengkap"),animated: true)
        }
        
    }
    
    //fungsi untuk menambahkan data
    func signUpUser() {
        let urlString = "https://fakestoreapi.com/users"
        guard let url = URL(string: urlString) else { return }
        
        // Prepare the data to be sent in JSON format
        let userDetail = UserModel (
            email: emailText.text ?? "",
            password: passwordText.text ?? "",
            phone:  phoneText.text ?? "",
            username: userNameText.text ?? "",
            name: FullName(firstname: firstNameText.text ?? "", lastname: lastNameText.text ?? "")
        )
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(userDetail)
            //            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    // Handle error here (e.g., show an alert)
                    return
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(json)")
                        
                        //                        self.saveUserDefault(userDetail)
                        //                        self.checkUserDefaultsData()
                        
                        DispatchQueue.main.async {
                           print("berhasil)")
                        }
                        
                    } catch {
                        print("Error parsing JSON: \(error)")
                        // Handle error in parsing JSON response
                    }
                }
            }.resume()
        } catch {
            print("Error creating JSON data: \(error)")
            // Handle error in creating JSON data
        }
    }
    
  
    
    @IBAction func backActionBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
