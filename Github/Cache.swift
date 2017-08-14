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
    //Mark: - image
    static let imageCache = UserDefaults.standard
    
    //Mark: - subscribe
    static let subscribeCacheKey = "subscribe"
    static let subscribeCache = AppCache(subscribeCacheKey)
    
    //Mark: - userProfile
    static let profileCacheKey = "selfProfile"
    static let profileCache = AppCache(profileCacheKey)
    
    //Mark: - currentUser
    static let currentUserKey = "currentUser"
    static let currentUserCache = AppCache(currentUserKey)
    
    static func set(_ key : String, _ value : Any?){
        Cache.imageCache.set(value, forKey: key)
    }

    
}
