//
//  UserModel.swift
//  Github
//
//  Created by Nathan on 04/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Haneke

typealias SJSON = SwiftyJSON.JSON

class UserModel{
    var userName : String
    var email : String
    var password : String
    
    init(_ userName : String, _ email : String , _ password : String) {
        self.userName = userName
        self.email = email
        self.password = password
    }
    
    convenience init(_ json : SJSON){
        self.init(json["userName"].stringValue,
                  json["email"].stringValue,
                  json["password"].stringValue)
    }
    
    func toSwiftyJSON() -> SJSON {
        return SJSON([
            "userName" : userName,
            "email" : email,
            "password" : password,
            ])
    }
    
//    func toHanekeJSON() -> Haneke.JSON{
//        var userDictionary = [String : String]()
//        userDictionary["userName"] = userName
//        let hanekeJSON : Haneke.JSON
//        hanekeJSON.dictionary = userDictionary
//        return hanekeJSON
//    }
}
