//
//  UsersTableViewController.swift
//  Github
//
//  Created by Nathan on 15/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class UsersTableViewController: UITableViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Cache.usersCahce.value = ""
        loadCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Cache.usersCahce.addKeysuffix((userName + userType))
    }

    // MARK: - Model
    var commonUsers : [[TitleModule]] = []
    var userType : String = ""
    var userName : String = ""
    
    func loadCache(){
        if(Cache.usersCahce.isEmpty){
            refreshCache()
            return
        }
        
        var userList : [TitleModule] = []
        commonUsers.removeAll()
        
        let value = Cache.usersCahce.value
        let json = JSON.parse(value)
        
        for user in json{
            let userString = user.1
            
            let userName = userString["login"].stringValue
            let userID = userString["id"].stringValue
            let imageUrl = userString["avatar_url"].stringValue
            let homeUrl = userString["html_url"].stringValue
            let followers = userString["followers"].stringValue
            let followersUrl = userString["followers_url"].stringValue
            let repos = userString["public_repos"].stringValue
            let reposUrl = userString["repos_url"].stringValue
            let followings = userString["following"].stringValue
            let followingsUrl = userString["following_url"].stringValue
            let user = TitleModule(userName,
                                   userID,
                                   imageUrl,
                                   homeUrl,
                                   followers,
                                   followersUrl,
                                   repos,
                                   reposUrl,
                                   followings,
                                   followingsUrl)
            userList.append(user)
        }
        commonUsers.append(userList)
        tableView.reloadData()
        hideProgressDialog()
    }
    
    func refreshCache(){
        showProgressDialog()
        Cache.usersCahce.detailRequest(userName, userType) {
            self.loadCache()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return commonUsers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonUsers[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Users", for: indexPath)
        let user = commonUsers[indexPath.section][indexPath.row]
        if let usersCell = cell as? UsersTableViewCell{
            usersCell.user = user
        }
        return cell
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
