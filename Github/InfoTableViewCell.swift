//
//  InfoTableViewCell.swift
//  Github
//
//  Created by Nathan on 12/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoTypeImage: UIImageView!
    var info : InfoModule? { didSet { updateUI() } }
    
    private func updateUI(){
        infoTypeImage.contentMode = .scaleAspectFit
        if let type = info?.imageType{
            switch type {
            case "blog":
                infoTypeImage.image = #imageLiteral(resourceName: "blog.png")
            case "starsRepo":
                infoTypeImage.image = #imageLiteral(resourceName: "star.png")
            case "organazation":
                infoTypeImage.image = #imageLiteral(resourceName: "organazation.png")
            case "location":
                infoTypeImage.image = #imageLiteral(resourceName: "location.png")
            case "mailBox":
                infoTypeImage.image = #imageLiteral(resourceName: "mailbox.png")
            default:
                infoTypeImage.image = nil
            }
        }
        infoLabel.text = info?.infoName
    }
}
