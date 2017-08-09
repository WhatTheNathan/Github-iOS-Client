//
//  ApiHelper.swift
//  Github
//
//  Created by Nathan on 05/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class ApiHelper
{
    static let client_id : String = "686efcf0d561925ce5aa"
    static let cilent_secret : String = "1282e3119c97c105d7fc5441155a1780267f1307"
    static let API_Root : String = "https://api.github.com"
    static let getCodeUrl : String = "https://github.com/login/oauth/authorize?client_id=" + client_id + "&scope=user,public_repo"
    static let getAccess_TokenUrl : String = "https://github.com/login/oauth/access_token?client_id=" + client_id + "&client_secret=" + cilent_secret + "&code="
    
    static var code : String = ""
    static var access_token : String = ""
    
    static var currentUserName: String = ""
}
