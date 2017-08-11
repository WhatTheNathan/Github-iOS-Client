//
//  LoginViewController.swift
//  Github
//
//  Created by Nathan on 05/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke


class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    var user = UserModel("","","")
    
    //Mark: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if ApiHelper.code != ""{
            requestAccess_Token()
        }
    }
    
    //Mark: - network request
    private func requestAccess_Token(){
        Alamofire.request(ApiHelper.getAccess_TokenUrl+ApiHelper.code).responseString{response in
            switch response.result.isSuccess {
            case true:
                //Mark: print
                let responseString = String(describing: response)
                let fromIndex = responseString.index(responseString.startIndex,offsetBy: 22)
                let toIndex = responseString.index(responseString.startIndex,offsetBy: 62)
                let range = fromIndex..<toIndex
                let access_token = responseString.substring(with: range)
                ApiHelper.access_token = access_token
                self.requestUserInfo(completionHandler: self.completionHandler)
            case false:
                print(response.result.error!)
            }
        }
    }
    
    private func requestUserInfo(completionHandler: @escaping () -> ()){
        Alamofire.request(ApiHelper.API_Root + "/user?access_token=" + ApiHelper.access_token).responseJSON {response in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    let json = SwiftyJSON.JSON(value)
                    self.user.userName = json["login"].stringValue
                    self.user.email = json["email"].stringValue
                }
                completionHandler()
            case false:
                print(response.result.error!)
            }
        }
    }
    
    private func completionHandler(){        
        ApiHelper.currentUser = user
//        performSegue(withIdentifier: "login", sender: LoginViewController.self)
    }

    
    
    // MARK: - Segue
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        return true
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "oauth"{
            if let webMVC = destinationViewController as? WebViewController{
                let url = URL(string: ApiHelper.getCodeUrl)
                webMVC.webUrl = url
                webMVC.navigationItem.title = "Github Authentication"
            }
        }
    }
}
