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

class SubscribeTableViewCell: UITableViewCell{
    var vcDelegate : SubscribeTableViewControllerDelegate?
    
    @IBOutlet weak var UserProfileImgaeView: UIImageView!
    @IBOutlet weak var MovementLabel: UILabel!
    {
        didSet{
            MovementLabel.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapEvent(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            MovementLabel.addGestureRecognizer(tapRecognizer)
        }
    }
    @IBOutlet weak var CreatedTimeLabel: UILabel!
    
    var subscribeMovement : SubscribeModel?{ didSet{ updateUI() } }
    
    func tapEvent(byReactingTo tapRecognizer: UITapGestureRecognizer){
        //calculate boundRect
        let tuple = caculateSize()
        let UserNameTextRect = tuple.0
        let repoRectArray = tuple.1

        //tap logic
        if tapRecognizer.state == .ended{
            let postion = tapRecognizer.location(in: MovementLabel)
//            print(postion)
            if UserNameTextRect.contains(postion){
                print("userName didTap")
                vcDelegate?.cellUserNameDidTap(sender: self)
            }
            
            for repoRect in repoRectArray{
                if(repoRect.contains(postion)){
                    print("repo didTap")
                    vcDelegate?.cellRepoDidTap(sender: self)
                }
            }
        }
    }
    
    private func caculateSize() -> (CGRect , [CGRect]){
        let commonAttribute : NSDictionary = [ NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        let option : NSStringDrawingOptions = .usesLineFragmentOrigin
        
        //userNameTextSize
        let userNameText = (subscribeMovement?.userName)!
        let nsUserNameText = userNameText as NSString
        let size = CGSize(width: 270, height: 0)
        let userNameTextRect = nsUserNameText.boundingRect(with: size, options: option, attributes: commonAttribute as? [String : Any], context: nil)
        let finalUserNameTextRect = CGRect(origin: CGPoint(x: 18,y: 8), size: userNameTextRect.size)
        
        //typeSize
        let actionText = (subscribeMovement?.action)! + "  "
        let nsActionText = actionText as NSString
        let actionRect = nsActionText.boundingRect(with: size, options: option, attributes: commonAttribute as? [String : Any], context: nil)
        
        //repoTextSize
        var repoRectArray : [CGRect] = []
        
        let repoText = (subscribeMovement?.repoName)!
        let nsRepoText = repoText as NSString
        let initialWidth = 280 - userNameTextRect.width - actionRect.width
        let containSize = CGSize(width: initialWidth, height: 0)
        let repoRect = nsRepoText.boundingRect(with: containSize, options: option, attributes: commonAttribute as? [String : Any], context: nil)
        
        let repoRect_1 = CGRect(origin: CGPoint(x: initialWidth, y: 8), size: repoRect.size)
        repoRectArray.append(repoRect_1)
        
        if repoRect.size.width > 20.3{
            let range = Convert.convertLengthToRange(Double(initialWidth), 17)
            let usedLength = range.length
            let remainRange = NSRange(location: usedLength, length: nsRepoText.length)
            let remainText = repoText.substring(remainRange)
            let nsRemainText = remainText as NSString
            let remainTextRect = nsRemainText.boundingRect(with: size, options: option, attributes: commonAttribute as? [String : Any], context: nil)
            let repoRect_2 = CGRect(origin: CGPoint(x: 0,y: 29), size: remainTextRect.size)
            repoRectArray.append(repoRect_2)
        }
        
        return (finalUserNameTextRect,repoRectArray)
    }

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
            case "created repository":
                attach.image = #imageLiteral(resourceName: "createdRepo.png")
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
