//
//  ReposTableViewCell.swift
//  Github
//
//  Created by Nathan on 14/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ReposTableViewCell: UITableViewCell {
    @IBOutlet weak var repoTypeImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var updatedTime: UILabel!
    
    var repo : ReposModel? { didSet { updateUI() } }
    
    private func updateUI(){
        repoTypeImage.contentMode = UIViewContentMode.scaleAspectFit
        if(repo?.repoType == "create"){
            repoTypeImage.image = #imageLiteral(resourceName: "createRepo.png")
        }else{
            repoTypeImage.image = #imageLiteral(resourceName: "fork.png")
        }
        
        let text =  repo?.repoName
        let nsText = text! as NSString
        let atributesText = NSMutableAttributedString.init(string: text!)
        let colorAttribute = [ NSForegroundColorAttributeName: UIColor.flatBlue ]
        let range = NSMakeRange(0, nsText.length)
        atributesText.addAttributes(colorAttribute, range: range)
        repoName.attributedText = atributesText
        
        repoDescription.text = repo?.description
        language.text = repo?.language
        
        updatedTime.text = repo?.updateTime.string()
        
    }
}
