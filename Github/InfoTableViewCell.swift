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
    
    var info : InfoModule? { didSet { updateUI() } }
    
    private func updateUI(){
        infoLabel.text = info?.infoName
    }
}
