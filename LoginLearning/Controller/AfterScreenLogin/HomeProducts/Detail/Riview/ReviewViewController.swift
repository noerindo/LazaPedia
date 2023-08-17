//
//  ReviewViewController.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 17/08/2566 BE.
//

import UIKit

class ReviewViewController: UIViewController {
    
    
    @IBOutlet weak var tableRiview: UITableView!
    
    @IBOutlet weak var addBtn: UIButton! {
        didSet {
            let size = CGSize(width: 20, height: 20)
            let rect = CGRect(origin: .zero, size: size)
            var image = UIImage(named: "Edit Square")
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            image?.draw(in: rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            addBtn.setImage(image, for: .normal)
            addBtn.layer.backgroundColor = UIColor(red: 1, green: 0.439, blue: 0.263, alpha: 1).cgColor
            addBtn.layer.cornerRadius = 10
            addBtn.addTarget(self, action: #selector(moveAdd), for: .touchUpInside)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRiview.dataSource = self
        tableRiview.delegate = self
        tableRiview.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        tableRiview.reloadData()

    }
    @objc func moveAdd() {
        let addRiviewVC = self.storyboard?.instantiateViewController(withIdentifier: "AddRiviewViewController") as! AddRiviewViewController
        self.navigationController?.pushViewController(addRiviewVC, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ReviewViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell {
            let cellList = riviewList[indexPath.item]
            cell.configureRiview(data: cellList)
            return cell
    }
        return UITableViewCell()
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}

