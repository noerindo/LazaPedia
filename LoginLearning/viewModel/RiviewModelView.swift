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
    
    func loadAllriviewl(id:Int) {
        getAllRiview(id: id) { result in
            DispatchQueue.main.async { [self] in
                guard let unwrappedVC = riviewVC else { return }
                var sortedResult = result
                sortedResult.data.reviews = result.data.reviews.sorted { $0.created_at > $1.created_at } // Sort by created at
                listRiview.append(contentsOf: sortedResult.data.reviews)
                unwrappedVC.tableRiview.reloadData()
                unwrappedVC.textRating.text = "\(sortedResult.data.rating_avrg)"
                unwrappedVC.starRating.rating = sortedResult.data.rating_avrg
                unwrappedVC.countRiview.text = "\(sortedResult.data.total)"
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
//                result.data.reviews = result.data
                completion(result)
            } catch {
                print("riview Gagal: \(error)")
            }
        }
        task.resume()
    }
    
    func postRiview(id: Int, comment: String, rating: Double, completion: @escaping((String) -> Void), onError: @escaping(String) -> Void) {
        let param = [
            "comment": comment,
            "rating": rating
        ] as [String : Any]
        
        guard let url = URL(string: Endpoints.Gets.riview(id: id).url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let accesToken = KeychainManager.shared.getToken()
        request.setValue("Bearer \(accesToken)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param)
        } catch {
            print("Error created riview data JSON")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpRespon = response as? HTTPURLResponse else { return}
            guard let data = data else { return }
            print(httpRespon.statusCode)
            if httpRespon.statusCode != 201 {
                guard let createFailed = try? JSONDecoder().decode(ResponFailed.self, from: data) else {
                    onError("addRiview Failed")
                    return
                }
                onError(createFailed.description)
                return
            }
            do {
                let result = try JSONDecoder().decode(ResponAddRiview.self, from: data)
                completion(result.status)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}


