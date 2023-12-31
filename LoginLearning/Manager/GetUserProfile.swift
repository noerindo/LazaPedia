//
//  GetUserProfile.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 27/07/2566 BE.
//

import Foundation

class AcountRegis {
    
    static func invalidEmail(email: String) -> Bool {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: email)
    }
    static func invalidPassword(pass: String) -> Bool {
        let regexPass =  #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexPass)
        return predicate.evaluate(with: pass)
    }
    
    static func invalidUserNAme(userName: String) -> Bool {
        let regexUserName = "\\w{7,18}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", userName)
        return predicate.evaluate(with: userName)
    }
    
    static func invalidNoHp(noHp: String) -> Bool {
        let regexNumberHp = "[+62801][0-9]{10,14}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexNumberHp)
        return predicate.evaluate(with: noHp)
    }
    
}

class RememberUser {
    
    func loginDefault(isLogin: Bool, userName: String) {
        UserDefaults.standard.set(userName, forKey: "UserName")
        UserDefaults.standard.set(isLogin, forKey: "isLogin")
    }


}
