//
//  SubscribeTableViewCell.swift
//  Github
//
//  Created by Nathan on 09/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import ChameleonFramework

class SubscribeTableViewCell: UITableViewCell {
    @IBOutlet weak var UserProfileImgaeView: UIImageView!
    @IBOutlet weak var MovementLabel: UILabel!
    @IBOutlet weak var CreatedTimeLabel: UILabel!
    
    var subscribeMovement : SubscribeModel?{ didSet{ updateUI() } }
    
    private func updateUI(){
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
        let para = subscribeMovement?.description
        let amountText = NSMutableAttributedString.init(string: para!)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.flatBlue ]
        amountText.addAttributes(colorAttribute, range: (subscribeMovement?.userNameRange)!)
        amountText.addAttributes(colorAttribute, range: (subscribeMovement?.repoNameRange)!)
        MovementLabel.attributedText = amountText
        
        CreatedTimeLabel.text = subscribeMovement?.created.string()
        
    }
}
