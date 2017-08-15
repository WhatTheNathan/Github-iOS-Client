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
import Moya

class Cache{
//    private func providerCreator() -> MoyaProvider<ApiConfig> {
//        let provider = MoyaProvider<ApiConfig>()
//        return provider
//    }
    
    //Mark: - image
    static let imageCache = UserDefaults.standard
    
    static func set(_ key : String, _ value : Any?){
        Cache.imageCache.set(value, forKey: key)
    }
    
    //Mark: - subscribe
    static let subscribeCacheKey = "subscribe"
    static let subscribeCache = AppCache(subscribeCacheKey){
        let provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - userProfile
    static let profileCacheKey = "selfProfile"
    static let profileCache = AppCache(profileCacheKey) {
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }

    //Mark: - currentUser
    static let currentUserKey = "currentUser"
    static let currentUserCache = AppCache(currentUserKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - repos
    static let reposKey = "reposList"
    static let reposCache = AppCache(reposKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
    
    //Mark: - users
    static let usersKey = "users"
    static let usersCahce = AppCache(usersKey){
        var provider = MoyaProvider<ApiConfig>()
        return provider
    }
}
