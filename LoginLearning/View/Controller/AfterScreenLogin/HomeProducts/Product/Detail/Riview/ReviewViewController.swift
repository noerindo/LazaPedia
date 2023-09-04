//
//  ReviewViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController {
    
    let riviewMV = RiviewViewModel()
    var idProduct: Int = 0
    
    @IBOutlet weak var countRiview: UILabel!
    @IBOutlet weak var textRating: UILabel!
    @IBOutlet weak var tableRiview: UITableView!
    
    @IBOutlet weak var starRating: CosmosView! {
        didSet {
            starRating.settings.fillMode = .precise
            starRating.settings.updateOnTouch = false
            starRating.settings.totalStars = 5
            starRating.settings.starMargin = 1
        }
    }
    @IBOutlet weak var addBtn: UIButton! {
        didSet {
            let size = CGSize(width: 15, height: 15)
            let rect = CGRect(origin: .zero, size: size)
            var image = UIImage(named: "Edit Square")
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            image?.draw(in: rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            addBtn.setImage(image, for: .normal)
            addBtn.setTitle("Add Review", for: .normal)
            addBtn.titleLabel?.font = UIFont(name: "Inter-Medium", size: 11)
            addBtn.layer.backgroundColor = UIColor(red: 1, green: 0.439, blue: 0.263, alpha: 1).cgColor
            addBtn.layer.cornerRadius = 5
            addBtn.addTarget(self, action: #selector(moveAdd), for: .touchUpInside)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRiview.dataSource = self
        tableRiview.delegate = self
        tableRiview.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        riviewMV.loadAllriviewl(id: idProduct) {
            DispatchQueue.main.async { [self] in
                tableRiview.reloadData()
                configureRiview(model: riviewMV.resultRiview!)
            }
        }
        

    }
    
    func configureRiview(model: DataIdRiview) {
        textRating.text = "\(model.rating_avrg)"
        starRating.rating = model.rating_avrg
        countRiview.text = "\(model.total)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        riviewMV.loadAllriviewl(id: idProduct) {
            DispatchQueue.main.async { [self] in
                tableRiview.reloadData()
                configureRiview(model: riviewMV.resultRiview!)
            }
        }
        
    }
    @objc func moveAdd() {
        let addRiviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AddRiviewViewController") as! AddRiviewViewController
        addRiviewVC.idProduct = idProduct
        self.navigationController?.pushViewController(addRiviewVC, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ReviewViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riviewMV.riviewAllCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell {
            let cellList = riviewMV.listRiview [indexPath.item]
            cell.configureRiview(data: cellList)
            return cell
    }
        return UITableViewCell()
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}

