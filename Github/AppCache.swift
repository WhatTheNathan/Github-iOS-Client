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
import Moya

class AppCache{
    static let myCache = UserDefaults.standard
    
    var key : String
    var value : String{
        set{
            set(key, newValue)
        }
        get{
            return get(key)
        }
    }
    
    var provider : MoyaProvider<ApiConfig>{
        return providerCreator()
    }
    
    let providerCreator : ()->MoyaProvider<ApiConfig>
    
    init(_ key : String , provider : @escaping () -> MoyaProvider<ApiConfig>) {
        self.key = key
        self.providerCreator = provider
    }
    
    var isEmpty : Bool{
        return value == ""
    }
    
    func detailRequest(_ userName : String , _ detail : String , completionHandler: @escaping ()->()) {
        provider.request(.userDetail(name: userName , detail: detail)) {result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func profileRequest(_ userName : String , completionHandler: @escaping ()->()) {
        provider.request(.userInfo(name: userName)) {result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data)
                self.set(self.key, json.rawString()!)
                completionHandler()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    private func get(_ key : String) -> String {
        if let value = AppCache.myCache.string(forKey: key){
            return value
        }
        return ""
    }
    
    func set(_ key : String, _ value : String) {
        AppCache.myCache.set(value, forKey: key)
    }
    
    func addKeysuffix(_ suffixKey : String){
        key += suffixKey
    }
}
