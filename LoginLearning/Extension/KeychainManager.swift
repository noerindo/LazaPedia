//
//  KeychainManager.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 18/08/2566 BE.
//

import Foundation
import Security

//class KeychainManager {
//    static let standard = KeychainManager()
//
//    func saveToken(accesToken: String) {
//        let query = [
//            kSecAttrService: accesToken
//        ] as [CFString : Any]
//        // Add data in query to keychain
//        let status = SecItemAdd(query as CFDictionary, nil)
//
//            if status != errSecSuccess {
//                // Print out the error
//                print("Error: \(status)")
//            }
//    }
//
//    func getToken(accesToken: String)-> String {
//        var result: AnyObject?
//        SecItemCopyMatching([kSecAttrService: accesToken] as CFDictionary, &result)
//        return accesToken
//    }
//
//    func deleteToken() {
//
//    }
//}

class KeychainManager {
    static let shared = KeychainManager()
    
    func saveToken(token: String) {
        let data = Data(token.utf8)
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any]
         let status = SecItemAdd(queary as CFDictionary, nil)
        
        let quearyUpdate = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        if updateStatus == errSecSuccess {
            print("Update, \(status)")
        }
        else if status == errSecSuccess {
            print("User saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
        
    }
    
    func getToken() -> String {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any]
       
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(queary as CFDictionary, &ref)
              if status == errSecSuccess{
                  print("berhasil keychain profile")
              } else {
                  print("gagal, status: \(status)")
              }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteToken() {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: true
        ] as [CFString : Any]
        
        if SecItemDelete(queary as CFDictionary) == errSecSuccess {
            print("Deleted from keychain")
        } else {
            print("Delete from keychain failed")
        }
        
    }
}
