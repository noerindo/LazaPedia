//
//  KodePassViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 16/08/2566 BE.
//

import UIKit
import DPOTPView

class KodePassViewController: UIViewController {

    @IBOutlet weak var timerView: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var inputCode: DPOTPView!
    var emailForgot: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func confirmCode(_ sender: UIButton) {
        guard let codeInput = inputCode.text else { return }
        if codeInput != "" {
            APICall().postCodeForgot(email: emailForgot, code: codeInput) { result in
                DispatchQueue.main.async {
                    if result == "code is valid" {
                        let moveVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        moveVC.email = self.emailForgot
                        moveVC.codeEmail = codeInput
                        self.navigationController?.pushViewController(moveVC, animated: true)
                        
                    } else {
                        SnackBarWarning.make(in: self.view, message: result, duration: .lengthShort).show()
                    }
                }
            } onError: { error in
                DispatchQueue.main.async {
                    SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                }
            }
        } else {
            SnackBarWarning.make(in: self.view, message: "Code is Empty", duration: .lengthShort).show()
        }
    }
    

}

extension KodePassViewController : DPOTPViewDelegate {
   func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}
