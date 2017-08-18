//
//  SubscribeTableViewCell.swift
//  Github
//
//  Created by Nathan on 09/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import ChameleonFramework
import SwiftDate

class SubscribeTableViewCell: UITableViewCell {
    @IBOutlet weak var UserProfileImgaeView: UIImageView!
    @IBOutlet weak var MovementLabel: UILabel!
    @IBOutlet weak var CreatedTimeLabel: UILabel!
    
    var subscribeMovement : SubscribeModel?{ didSet{ updateUI() } }
    
    private func updateUI(){
        //UserProfileImgaeView
        let imageKey = "eventImage"+(subscribeMovement?.eventID)!
        if let imageData = Cache.imageCache.data(forKey: imageKey){
            UserProfileImgaeView.image = UIImage(data: imageData)
        }else{
            if let profileImageURL = subscribeMovement?.imageUrl {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: profileImageURL)
                    Cache.set(imageKey, urlContents)
                    if let imageData = urlContents, profileImageURL == self?.subscribeMovement?.imageUrl{
                        DispatchQueue.main.async {
                            self?.UserProfileImgaeView.image = UIImage(data: imageData)
                        }
                    }
                }
            } else {
                UserProfileImgaeView?.image = nil
            }
        }
        
        //MovementLabel
        let attach = NSTextAttachment.init()
        if let actionString = subscribeMovement?.action{
            switch actionString {
            case "forked":
                attach.image = #imageLiteral(resourceName: "fork.png")
            case "starred":
                attach.image = #imageLiteral(resourceName: "star.png")
            default:
                attach.image = nil
            }
        }
        let attachString = NSAttributedString(attachment: attach)
        let finalAttributeString = NSMutableAttributedString.init(attributedString: attachString)
        
        let para = subscribeMovement?.description
        let amountText = NSMutableAttributedString.init(string: para!)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.flatBlue ]
        amountText.addAttributes(colorAttribute, range: (subscribeMovement?.userNameRange)!)
        amountText.addAttributes(colorAttribute, range: (subscribeMovement?.repoNameRange)!)
        
        finalAttributeString.append(amountText)
        MovementLabel.attributedText = finalAttributeString
        
        //CreatedTimeLabel
        var displayTime = ""
        if let time = subscribeMovement?.created{
            let nowDate = DateInRegion(absoluteDate: Date(), in: Region.Local())
            let intervalInMonth = (time - nowDate).in(.month)
            let intervalInDay = (time - nowDate).in(.day)
            let intervalInHour = (time - nowDate).in(.hour)
            let intervalInMinute = (time - nowDate).in(.minute)
            let intervalInSecond = (time - nowDate).in(.second)
            
            if intervalInMonth != 0 {
                displayTime = String(describing: intervalInMonth!) + " month"
            }else if intervalInDay != 0{
                displayTime = String(describing: intervalInDay!) + " day"
            }else if intervalInHour != 0{
                displayTime = String(describing: intervalInHour!) + " hour"
            }else if intervalInMinute != 0{
                displayTime = String(describing: intervalInMinute!) + " minute"
            }else if intervalInSecond != 0{
                displayTime = String(describing: intervalInSecond!) + " second"
            }
            if !displayTime.hasPrefix("1"){
                displayTime += "s"
            }
            displayTime += " ago"
        }
        
        CreatedTimeLabel.text = displayTime
        
    }
}
