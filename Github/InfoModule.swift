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
    
    init(_ infoName : String, _ infoUrl : String) {
        self.infoName = infoName
        self.infoUrl = infoUrl
    }
    
    convenience init(_ json : JSON){
        self.init(json["infoName"].stringValue,
                  json["infoUrl"].stringValue)
    }
    
    func toJSON() -> JSON {
        return JSON([
            "infoName" : infoName,
            "infoUrl" : infoUrl
            ])
    }
}
