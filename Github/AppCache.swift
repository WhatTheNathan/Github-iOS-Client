//
//  AppCache.swift
//  Github
//
//  Created by Nathan on 13/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AppCache{
    let key : String
    var value : String{
        set{
            set(key, newValue)
        }
        get{
            return get(key)
        }
    }
    
    static let myCache = UserDefaults.standard
    
    init(_ key : String) {
        self.key = key
    }
    
    var isEmpty : Bool{
        return value == ""
    }
    
    func dataRequest(_ api : String , completionHandler: @escaping ()->()) {
        print("here2")
        Alamofire.request(api).responseJSON {response in
            switch response.result.isSuccess{
            case true:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.set(self.key, json.rawString()!)
                }
                print("here3")
                completionHandler()
            case false:
                print(response.result.error!)
            }
        }
    }
    
    private func get(_ key : String) -> String {
        if let value = AppCache.myCache.string(forKey: key){
            return value
        }
        return ""
    }
    
    private func set(_ key : String, _ value : String) {
        AppCache.myCache.set(value, forKey: key)
    }
}
