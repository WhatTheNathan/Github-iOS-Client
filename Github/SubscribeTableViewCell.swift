//
//  SubscribeTableViewCell.swift
//  Github
//
//  Created by Nathan on 09/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class SubscribeTableViewCell: UITableViewCell {
    @IBOutlet weak var UserProfileImgaeView: UIImageView!
    @IBOutlet weak var MovementLabel: UILabel!
    @IBOutlet weak var CreatedTimeLabel: UILabel!
    
    var subscribeMovement : SubscribeModel?{ didSet{ updateUI() } }
    
    private func updateUI(){
        let imageKey = "eventImage"+(subscribeMovement?.eventID)!
        if let imageData = Cache.mainCache.data(forKey: imageKey){
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
        
        MovementLabel.text = subscribeMovement?.description
        
        CreatedTimeLabel.text = subscribeMovement?.created.string()
        
    }
}
