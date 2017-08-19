//
//  ReposTableViewCell.swift
//  Github
//
//  Created by Nathan on 14/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftDate

class ReposTableViewCell: UITableViewCell {
    @IBOutlet weak var repoTypeImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var updatedTime: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    @IBOutlet weak var forkNumberLabel: UILabel!
    var repo : ReposModel? { didSet { updateUI() } }
    
    private func updateUI(){
        repoTypeImage.contentMode = UIViewContentMode.scaleAspectFit
        if(repo?.repoType == "create"){
            repoTypeImage.image = #imageLiteral(resourceName: "createdRepo.png")
        }else{
            repoTypeImage.image = #imageLiteral(resourceName: "forkedRepo.png")
        }
        
        let text =  repo?.repoName
        let nsText = text! as NSString
        let atributesText = NSMutableAttributedString.init(string: text!)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.flatBlue ]
        let range = NSMakeRange(0, nsText.length)
        atributesText.addAttributes(colorAttribute, range: range)
        repoName.attributedText = atributesText
        
//        repoDescription.contentMode = .scaleAspectFit
//        repoDescription.sizeToFit()
        repoDescription.text = repo?.description
        
        language.text = repo?.language
        
        var displayTime = ""
        if let time = repo?.updateTime{
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
        
        updatedTime.text = displayTime
        
        starNumberLabel.text = repo?.starNumber
        forkNumberLabel.text = repo?.forkNumber
        
    }
}
