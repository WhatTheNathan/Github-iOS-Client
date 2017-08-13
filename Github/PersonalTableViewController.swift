//
//  PersonalTableViewController.swift
//  Github
//
//  Created by Nathan on 11/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonalTableViewController: UITableViewController {
    //MARK: - Model
    enum personalItem{
        case Title(TitleModule)
        case Info(InfoModule)
    }
    
    var profiles : [[personalItem]] = []
    
    // MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.flatBlack
        Cache.set(Cache.profileCacheKey, " ")
        loadCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadCache(){
        if(Cache.get(Cache.profileCacheKey) == " "){
            refreshCache()
            return
        }
        
        var titleProfile : [personalItem] = []
        var infoProfile : [personalItem] = []
        profiles.removeAll()
        let value = Cache.get(Cache.profileCacheKey)
        let json = JSON.parse(value)
        
        //parse titleModule
        let userName = json["login"].stringValue
        let imageUrl = json["avatar_url"].stringValue
        let followers = json["followers"].stringValue
        let repos = json["public_repos"].stringValue
        let followings = json["following"].stringValue
        let titlePass = personalItem.Title( TitleModule(userName,imageUrl,followers,repos,followings) )
        titleProfile.append(titlePass)
        profiles.append(titleProfile)
        
        //parse blog
        let blogName = json["blog"].stringValue
        let blogUrl = blogName
        let blogInfo = personalItem.Info( InfoModule(blogName,blogUrl) )
        infoProfile.append(blogInfo)
        
        //parse starsRepo
        let infoName = "Starred Repos"
        let starredReposUrl = json["starred_url"].stringValue
        let starredReposInfo = personalItem.Info( InfoModule(infoName,starredReposUrl) )
        infoProfile.append(starredReposInfo)
        
        profiles.append(infoProfile)
        hideProgressDialog()
        tableView.reloadData()
    }

    private func refreshCache() {
        showProgressDialog()
        Cache.profileRequest {
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
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
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

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == "Keyword"{
//            if let cell = sender as? MentionTableViewCell{
//                if let url = cell.mentionLabel.text{
//                    if url.hasPrefix("http"){
//                        //                        UIApplication.shared.open(URL(string: url)!)
//                        performSegue(withIdentifier: "Url", sender: sender)
//                        return false
//                    }
//                }
//            }
//        }
//        return true
//    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
    

}
