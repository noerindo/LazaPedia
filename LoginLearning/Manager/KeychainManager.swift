//
//  KeychainManager.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 18/08/2566 BE.
//

import Foundation
import Security
import JWTDecode

class KeychainManager {
    static let shared = KeychainManager()
    
    func saveToken(token: String) {
        let data = Data(token.utf8)
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any]
         let status = SecItemAdd(queary as CFDictionary, nil)
        
        let quearyUpdate = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        if updateStatus != errSecSuccess {
            print("Error update token, \(status)")
        }
        else if status != errSecSuccess {
            print("Error add token, \(status)")
        }
        
    }
    
    func getToken() -> String {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any]
       
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(queary as CFDictionary, &ref)
              if status != errSecSuccess{
                  print("error keychain , \(status)")
              }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteToken() {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let status = SecItemDelete(queary as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound {
            print("Delete from keychain success")
        }
    }
    
    func saveRefreshToken(token: String) {
        let data = Data(token.utf8)
        let queary = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any]
         let status = SecItemAdd(queary as CFDictionary, nil)
        
        let quearyUpdate = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        if updateStatus != errSecSuccess {
            print("Error update token, \(status)")
        }
        else if status != errSecSuccess {
            print("Error add token, \(status)")
        }
    }
    
    func getRefreshToken() -> String {
        let queary = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any]
       
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(queary as CFDictionary, &ref)
              if status != errSecSuccess{
                  print("error keychain , \(status)")
              }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteResfreshToken() {
        let queary = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        
        let status = SecItemDelete(queary as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound{
            print("Delete from access-token success")
        }
    }
    
    func getTokenValid() -> String {
        var tokenActiv: String = ""
        let accesToken = KeychainManager.shared.getToken()
        let refreshToken = KeychainManager.shared.getRefreshToken()
        do {
            let jwt = try decode(jwt: accesToken)
            if !jwt.expired {
                tokenActiv = accesToken
            } else {
                LoginVM().getRefreshToken(refreshToken: refreshToken)
                tokenActiv = accesToken
            }
        } catch {
            print("token none")
        }
        return tokenActiv
    }
    
    
}

