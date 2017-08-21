//
//  TitleTableViewCell.swift
//  Github
//
//  Created by Nathan on 12/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var reposButton: UIButton!
    @IBOutlet weak var FollowingButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var changeImage: UIImageView!
    
    var title : TitleModule? { didSet { updateUI() } }
    
    private func updateUI(){
        profileImage.contentMode = UIViewContentMode.scaleAspectFit
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = 10.0

        let profileImageKey = "ProfileImage" + (title?.userID)!
        let profileFilterImageKey = "ProfileFilterImage" + (title?.userID)!
        Cache.keySet.insert(profileImageKey)
        Cache.keySet.insert(profileFilterImageKey)
        
        if let imageData = Cache.tempImageCache.data(forKey: profileImageKey) , let filterData = Cache.tempImageCache.data(forKey: profileFilterImageKey){
            profileImage.image = UIImage(data: imageData)
            let filterImage = UIImage(data: filterData)
            changeImage.image = filterImage
        }else{
            if let imageUrl = URL(string: (title?.imageUrl)!){
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in //reference to image，self may be nil
                    let urlContents = try? Data(contentsOf: imageUrl)
                    let image = UIImage(data: urlContents!)
                    
                    let filterImage = image?.getGaussianBlur()
                    
                    Cache.tempImageSet(profileImageKey, urlContents)
                    
                    let filterData = UIImagePNGRepresentation(filterImage!)
                    Cache.tempImageSet(profileFilterImageKey,filterData)
                    if let imageData = urlContents{
                        DispatchQueue.main.async {
                            self?.profileImage.image = UIImage(data: imageData)
                            self?.changeImage.image = filterImage
                        }
                    }
                }
            }else{
                profileImage.image = nil
            }
        }
        
        followersButton.titleLabel?.numberOfLines = 0
        reposButton.titleLabel?.numberOfLines = 0
        FollowingButton.titleLabel?.numberOfLines = 0
        followersButton.titleLabel?.textAlignment = .center
        reposButton.titleLabel?.textAlignment = .center
        FollowingButton.titleLabel?.textAlignment = .center
        
        followersButton.setTitle("Followers\n" + (title?.followers)!, for: UIControlState(rawValue: 0))
        reposButton.setTitle("Repos\n" + (title?.repos)!, for: UIControlState(rawValue: 0))
        FollowingButton.setTitle("Followings\n" + (title?.followings)!, for: UIControlState(rawValue: 0))
        userNameLabel.text = title?.userName
        userNameLabel.textColor = UIColor.white
    }
}
