//
//  LauchScreenViewController.swift
//  Github
//
//  Created by Nathan on 12/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class LauchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if(Cache.get("currentUser") != " "){
            let sb = UIStoryboard(name: "main", bundle: nil)
            let tarBarController = sb.instantiateViewController(withIdentifier: "mainTarBarController")
            self.present(tarBarController, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
