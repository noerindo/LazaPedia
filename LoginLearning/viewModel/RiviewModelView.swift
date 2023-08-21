//
//  RiviewModelView.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 21/08/2566 BE.
//

import Foundation


class RiviewModelView {
    var listRiview = [ReviewProduct]()
    var riviewVC: ReviewViewController?
    
    var riviewAllCount: Int {
        get {
            return listRiview.count
        }
    }
    func loadAllriviewl(id:Int, completion: @escaping (() -> Void)) {
        getAllRiview(id: id) { result in
            DispatchQueue.main.async {
                guard let unwrappedVC = riviewVC else { return }
                unwrappedVC.textRating.text = "\(result.data.rating_avrg)"
                unwrappedVC.starRating.rating = result.data.rating_avrg
//                unwrappedVC.countRiview.text = "\(result.data.total) \(Re)"
            }
           
        }
    }
    func getAllRiview(id: Int, completion: @escaping((ResponRiview) -> Void)) {
        guard let url = URL(string: Endpoints.Gets.riview(id: id).url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(ResponRiview.self, from: data)
                completion(result)
            } catch {
                print("riview Gagal: \(error)")
            }
        }
        task.resume()
    }
}


