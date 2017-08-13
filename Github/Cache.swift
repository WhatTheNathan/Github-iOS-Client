//
//  Cache.swift
//  Github
//
//  Created by Nathan on 09/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Cache{
    static let mainCache = UserDefaults.standard
    
    //Mark: - subscribe
    static let subscribeCacheKey = "subscribe"
    static func subscribeRequest(completionHandler: @escaping ()->()) {
        //Mark: - print
        print("subscribeRequest")
        Alamofire.request(ApiHelper.API_Root+"/users/" + ApiHelper.currentUser.userName + "/received_events").responseJSON {response in
            switch response.result.isSuccess{
            case true:
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    Cache.set(Cache.subscribeCacheKey, json.rawString()!)
                }
                completionHandler()
            case false:
                print(response.result.error!)
            }
        }
    }
    
    //Mark: -userProfile
    static let profileCacheKey = "selfProfile"
    static func profileRequest(completionHandler: @escaping ()->()){
        //Mark: - print
        print("profileRequest")
        Alamofire.request(ApiHelper.API_Root+"/users/" + ApiHelper.currentUser.userName).responseJSON{ response in
            switch response.result.isSuccess{
            case true:
//                print(response)
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    Cache.set(Cache.profileCacheKey, json.rawString()!)
                }
                completionHandler()
            case false:
                print(response.result.error!)
            }
        }
    }
    
    static func get(_ key : String) -> String {
        if let value = Cache.mainCache.string(forKey: key){
            return value
        }
        return " "
    }
    
    static func set(_ key : String, _ value : String) {
        Cache.mainCache.set(value, forKey: key)
    }
    static func set(_ key : String, _ value : Any?){
        Cache.mainCache.set(value, forKey: key)
    }
    
}
