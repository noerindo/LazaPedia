//
//  AddRiviewViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class AddRiviewViewController: UIViewController {
    let riviewMV = RiviewModelView()
    var idProduct: Int = 0
    var ratingSlider: String = ""
    
    
    @IBOutlet weak var viewTextSlider: UILabel!
    @IBOutlet weak var sliderRating: CustomSlider!
    @IBOutlet weak var inputRiview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sliderAction(_ sender: CustomSlider) {
        viewTextSlider.text =  String(format: "%.1f", sender.value)
        ratingSlider = String(format: "%.1f", sender.value)
        
    }
    
    @IBAction func addRiviewAct(_ sender: UIButton) {
        guard let comment = inputRiview.text else { return }
//        let ratingString = viewTextSlider.text!
        guard let rating = Double(viewTextSlider.text!) else {return }
        print(rating)
        if comment != "" {
            riviewMV.postRiview(id: idProduct, comment: comment, rating: rating) { respon in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Add Riview Success", preferredStyle: .alert)
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
            SnackBarWarning.make(in: self.view, message: "Coment empthy", duration: .lengthShort).show()
        }
        
    }
}
