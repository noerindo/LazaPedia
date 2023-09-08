//
//  KodePassViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 16/08/2566 BE.
//

import UIKit
import DPOTPView

class KodePassViewController: UIViewController {
    private var viewModel: KodePassViewVM!
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!{
        didSet {
            loadingView.isHidden = true
        }
    }
    
    @IBOutlet weak var timerView: UILabel!
    @IBOutlet weak var inputCode: DPOTPView!
    var totalTime = 300
    var countdownTimer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        starCountDown()
    }
    
    func loadingStop() {
        self.loadingView.stopAnimating()
        self.loadingView.hidesWhenStopped = true
    }
    
    
    private func starCountDown() {
       countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
       timerView.text = "\(timeFormatted(totalTime))"
               if totalTime != 0 {
                   totalTime -= 1
               } else {
                   countdownTimer.invalidate()
                   SnackBarWarning.make(in: self.view, message: "time is up, send the verification code again", duration: .lengthShort).show()
               }
    }
        
    func timeFormatted(_ totalSeconds: Int) -> String {
            let seconds: Int = totalSeconds % 60
            let minutes: Int = (totalSeconds / 60) % 60
            //     let hours: Int = totalSeconds / 3600
            return String(format: "%02d:%02d", minutes, seconds)
        }
    
    func configure(email: String) {
        viewModel = KodePassViewVM(emailForgot: email)
    }

    @IBAction func confirmCode(_ sender: UIButton) {
        loadingView.isHidden = false
        loadingView.startAnimating()
        guard let codeInput = inputCode.text else { return }
        
        if codeInput != "" {
            viewModel.postCodeForgot(code: codeInput) { result in
                DispatchQueue.main.async { [self] in
                    self.loadingStop()
                    if result == "code is valid" {
                        let moveVC = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                        moveVC.configure(code: codeInput, email: self.viewModel.emailForgot)
                        self.navigationController?.pushViewController(moveVC, animated: true)
                        
                    } else {
                        self.loadingStop()
                        SnackBarWarning.make(in: self.view, message: result, duration: .lengthShort).show()
                    }
                }
            } onError: { error in
                DispatchQueue.main.async {
                    self.loadingStop()
                    SnackBarWarning.make(in: self.view, message: error, duration: .lengthShort).show()
                }
            }
        } else {
            self.loadingStop()
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
