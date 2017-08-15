//
//  UsersTableViewCell.swift
//  Github
//
//  Created by Nathan on 15/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var homePageLabel: UILabel!
    
    var user : TitleModule? { didSet{ updateUI() } }
    
    private func updateUI(){
        avatarImage.contentMode = UIViewContentMode.scaleAspectFit
        let avatarImageKey = "avatarImage" + (user?.userID)!
        if let imageData = Cache.imageCache.data(forKey: avatarImageKey){
            avatarImage.image = UIImage(data: imageData)
        }else{
            if let imageUrl = URL(string: (user?.imageUrl)!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    Cache.set(avatarImageKey, urlContents)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.avatarImage.image = UIImage(data: imageData)
                        }
                    }
                }
            }else{
                avatarImage.image = nil
            }
        }
        
        userNameLabel.text = user?.userName
        homePageLabel.text = user?.homeUrl
    }
}
