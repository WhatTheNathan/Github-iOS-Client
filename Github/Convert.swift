//
//  Convert.swift
//  Github
//
//  Created by Nathan on 21/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

class Convert{
    static func convertLengthToRange(_ length : Double , _ fontSize : CGFloat) -> NSRange{
        let commonAttribute : NSDictionary = [ NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)]
        let option : NSStringDrawingOptions = .usesLineFragmentOrigin
        
        var text = "a"
        while true {
            let nsText = text as NSString
            let size = CGSize(width: length, height: 0.0)
            let rect = nsText.boundingRect(with: size, options: option, attributes: commonAttribute as? [String : Any], context: nil)
            if rect.size.height > 20.3{
                break
            }
            text += "a"
        }
        let nsFinalText = text as NSString
        let range = NSRange(location: 0, length: nsFinalText.length)
        return range
    }
    
}
