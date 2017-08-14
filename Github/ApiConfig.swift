//
//  ApiConfig.swift
//  Github
//
//  Created by Nathan on 14/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Moya

enum ApiConfig{
    case userInfo(name: String)
    case userEvent(name: String , event: String)
}

extension ApiConfig: TargetType{
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var path: String{
        switch self {
        case .userInfo(let name):
            return "/users/" + name
        case .userEvent(let name , let event):
            return "/users/" + name + "/" + event
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .userInfo, .userEvent:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .userInfo, .userEvent:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .userInfo, .userEvent:
            return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
        }
    }
    
    var sampleData: Data {
        switch self {
        case .userInfo(let name):
            return "{\"UserName\": \(name)}".utf8Encoded
        case .userEvent(let name, let event):
            return "{\"UserName\": \(name) , \"Event\": \(event)}".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .userInfo, .userEvent:
            return .request
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}
