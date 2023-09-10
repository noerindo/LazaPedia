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
    
    //Menyimpan data profile
    func saveProfileToKeychain(profile: DataProfileUser) {
        guard let data = try? JSONEncoder().encode(profile) else {
            print("Encode error")
            return
        }
        let addquery = [
            kSecAttrService: "profile",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: "profile",
                kSecAttrAccount: "lazaPedia-accoun",
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus != errSecSuccess {
                print("Error updating profile to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding token to keychain, status: \(status)")
        }
    }
    
    //Mendapatkan data profile
    func getProfileFromKeychain() -> DataProfileUser? {
        
        let getquery = [
            kSecAttrService: "profile",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(getquery, &ref)
        guard status == errSecSuccess else {
            // Error
            print("Error retrieving refresh token from keychain, status: \(status)")
            return nil
        }
        let data = ref as! Data
        guard let dataProfile = try? JSONDecoder().decode(DataProfileUser.self, from: data) else {
            print("Encode error")
            return nil
        }
        return dataProfile
    }
    // delet
    func deleteProfileFromKeychain() {
        let queary = [
            kSecAttrService: "profile",
            kSecAttrAccount: "lazaPedia-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        
        let status = SecItemDelete(queary as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound{
            print("Delete profile success")
        }
    }
    
}

