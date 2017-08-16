//
//  PersonalTableViewController.swift
//  Github
//
//  Created by Nathan on 11/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum infoItem{
    case Url
    case Segue
    case Display
}

class PersonalTableViewController: UITableViewController {
    //MARK: - Model
    enum personalItem{
        case Title(TitleModule)
        case Info(InfoModule)
    }
    
    var profiles : [[personalItem]] = []
    var profileUserName : String = ApiHelper.currentUser.userName
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Cache.profileCache.setKeysuffix(profileUserName)
        loadCache()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor.flatWhite
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadCache(){
        if(Cache.profileCache.isEmpty){
            refreshCache()
            return
        }
        
        var titleProfile : [personalItem] = []
        var infoProfile : [personalItem] = []
        profiles.removeAll()
        let value = Cache.profileCache.value
        let json = JSON.parse(value)
        
        //parse titleModule
        let userName = json["login"].stringValue
        let userID = json["id"].stringValue
        let imageUrl = json["avatar_url"].stringValue
        let homeUrl = json["html_url"].stringValue
        let followers = json["followers"].stringValue
        let followersUrl = json["followers_url"].stringValue
        let repos = json["public_repos"].stringValue
        let reposUrl = json["repos_url"].stringValue
        let followings = json["following"].stringValue
        let followingsUrl = json["following_url"].stringValue
        let titlePass = personalItem.Title( TitleModule(userName,
                                                        userID,
                                                        imageUrl,
                                                        homeUrl,
                                                        followers,
                                                        followersUrl,
                                                        repos,
                                                        reposUrl,
                                                        followings,
                                                        followingsUrl) )
        titleProfile.append(titlePass)
        profiles.append(titleProfile)
        
        //parse starsRepo
        let infoName = "Starred Repos"
        let starredReposUrl = json["starred_url"].stringValue
        let starsRepoType = infoItem.Segue
        let starsRepoImageType = "starsRepo"
        let starredReposInfo = personalItem.Info( InfoModule(infoName,starredReposUrl,starsRepoType,starsRepoImageType) )
        infoProfile.append(starredReposInfo)
        
        //parse blog
        let blogName = json["blog"].stringValue
        let blogUrl = blogName
        let blogType = infoItem.Url
        let blogImageType = "blog"
        let blogInfo = personalItem.Info( InfoModule(blogName,blogUrl,blogType,blogImageType) )
        infoProfile.append(blogInfo)
        
        //parse organazation
        var organazationName = "Not Set"
        let organazationType = infoItem.Display
        let organazationImageType = "organazation"
        if (json["company"].stringValue != ""){
            organazationName = json["company"].stringValue
        }
        let orgInfo = personalItem.Info(InfoModule(organazationName,"",organazationType,organazationImageType))
        infoProfile.append(orgInfo)
        
        //parse location
        var locationName = "Not Set"
        let locationType = infoItem.Display
        let locationImageType = "location"
        if json["location"].stringValue != ""{
            locationName = json["location"].stringValue
        }
        let locationInfo = personalItem.Info(InfoModule(locationName,"",locationType,locationImageType))
        infoProfile.append(locationInfo)
        
        //parse mailBox
        var mailBoxName = "Not Set"
        let mailBoxType = infoItem.Display
        let mailBoxImageType = "mailBox"
        if json["email"].stringValue != ""{
            mailBoxName = json["email"].stringValue
        }
        let mailBoxInfo = personalItem.Info(InfoModule(mailBoxName,"",mailBoxType,mailBoxImageType))
        infoProfile.append(mailBoxInfo)
        
        profiles.append(infoProfile)
        tableView.reloadData()
        hideProgressDialog()
    }

    private func refreshCache() {
        showProgressDialog()
        Cache.profileCache.profileRequest(profileUserName) {
            self.loadCache()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return profiles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let profile = profiles[indexPath.section][indexPath.row]
        switch profile{
        case .Title( _):
            return 278
        case .Info( _):
            return 54
//        default:
//            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profiles[indexPath.section][indexPath.row]
        switch profile {
        case .Title(let tempTitleModule):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Title Cell", for: indexPath) as! TitleTableViewCell
            cell.title = tempTitleModule
            return cell
        case .Info(let tempInfoModule):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Info Cell", for: indexPath) as! InfoTableViewCell
            cell.info = tempInfoModule
            return cell
        }
    }

    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "starRepos"{
            if let cell = sender as? InfoTableViewCell{
                if let infoType = cell.info?.infoType{
                    if infoType == .Url{
                        performSegue(withIdentifier: "infoUrl", sender: sender)
                        return false
                    }
                    if infoType == .Display{
                        return false
                    }
                }
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "followers"{
            if let usersVC = destinationViewController as? UsersTableViewController{
                usersVC.userType = "followers"
                usersVC.userName = profileUserName
                usersVC.navigationItem.title = "Followers"
            }
        }
        if segue.identifier == "following"{
            if let usersVC = destinationViewController as? UsersTableViewController{
                usersVC.userType = "following"
                usersVC.userName = profileUserName
                usersVC.navigationItem.title = "Following"
            }
        }
        if segue.identifier == "ownRepos"{
            if let repoVC = destinationViewController as? ReposTableViewController{
                repoVC.repoOwner = profileUserName
                repoVC.reposType = "repos"
                repoVC.navigationItem.title = "Repos"
            }
        }
        if segue.identifier == "starRepos"{
            if let repoVC = destinationViewController as? ReposTableViewController{
                repoVC.repoOwner = profileUserName
                repoVC.reposType = "starred"
                repoVC.navigationItem.title = "Starred Repos"
            }
        }
        if segue.identifier == "infoUrl"{
            if let webMVC = destinationViewController as? WebViewController{
                if let cell = sender as? InfoTableViewCell{
                    let urlString = cell.info?.infoUrl
                    let url = URL(string: urlString!)
                    webMVC.webUrl = url
                    webMVC.navigationItem.title = "Blog"
                }
            }
        }
    }
}
