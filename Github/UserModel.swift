//
//  UserModel.swift
//  Github
//
//  Created by Nathan on 04/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel{
    var userName : String
    var email : String
    var password : String
    
    init(_ userName : String, _ email : String , _ password : String) {
        self.userName = userName
        self.email = email
        self.password = password
    }
    
    func toJson() -> JSON {
        return JSON([
            "userName" : userName,
            "email" : email,
            "password" : password,
            ])
    }
}
