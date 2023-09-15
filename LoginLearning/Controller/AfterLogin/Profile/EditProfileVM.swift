//
//  EditProfileVM.swift
//  LoginLearning
//
//  Created by Indah Nurindo on 07/09/2566 BE.
//

import Foundation

class EditProfileVM{
    let networkAPI = NetworkAPI()
   
    private(set) var updateProfile: DataProfileUser
    
    init(updateProfile: DataProfileUser) {
        self.updateProfile = updateProfile
    }
    
}
