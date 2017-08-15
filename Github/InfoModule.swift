//
//  InfoModule.swift
//  Github
//
//  Created by Nathan on 12/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SwiftyJSON

class InfoModule{
    var infoName : String
    var infoUrl : String
    var infoType : infoItem
    var imageType : String
    
    init(_ infoName : String,
         _ infoUrl : String,
         _ infoType : infoItem,
         _ imageType : String) {
        self.infoName = infoName
        self.infoUrl = infoUrl
        self.infoType = infoType
        self.imageType = imageType
    }
    
//    convenience init(_ json : JSON){
//        self.init(json["infoName"].stringValue,
//                  json["infoUrl"].stringValue,
//                  json["infoType"].stringValue)
//    }
//    
//    func toJSON() -> JSON {
//        return JSON([
//            "infoName" : infoName,
//            "infoUrl" : infoUrl,
//            "infoType" : infoType
//            ])
//    }
}
