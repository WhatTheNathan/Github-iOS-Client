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
    
    var subscribeMovement : SubscribeModel?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        if let profileImageURL = subscribeMovement?.imageUrl {
            if let url = URL(string: profileImageURL){
                // FIXME: blocks main thread
                if let imageData = try? Data(contentsOf: url) {
                    UserProfileImgaeView?.image = UIImage(data: imageData)
                }
            }
        } else {
            UserProfileImgaeView?.image = nil
        }
        
        MovementLabel.text = subscribeMovement?.userName
        CreatedTimeLabel.text = subscribeMovement?.created
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
