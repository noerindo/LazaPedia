//
//  APIcall.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 26/07/2566 BE.
//

import Foundation
import Alamofire

class APICall {
    static let sharedApi = APICall()
    private let baseUrlUser = "https://fakestoreapi.com/users"
    
    func fetchAPIUser(completion: @escaping (UserIndex) -> Void){
        AF.request(baseUrlUser, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response{ resp in
                switch resp.result{
                case .success(let data):
                    do{
                        let jSonData = try JSONDecoder().decode(UserIndex.self, from: data!)
                        completion(jSonData)
                        print("berhasil")
                    } catch{
                        print(error)
                        print("error")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
        

     

   
    func postUser(){
        let param: [String: String] = [:]
        AF.request(baseUrlUser, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).response{ resp in switch resp.result{
        case .success(let data):
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
                                        print("Error: Cannot convert data to JSON object")
                                        return
                                    }
                                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                                        print("Error: Cannot convert JSON object to Pretty JSON data")
                                        return
                                    }
                                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                                        print("Error: Could print JSON in String")
                                        return
                                    }
                            
                                    print(prettyPrintedJson)
                                } catch {
                                    print("Error: Trying to convert JSON data to string")
                                    return
                                }
                            case .failure(let error):
                                print(error)
            }
        }}
    }
    
    

