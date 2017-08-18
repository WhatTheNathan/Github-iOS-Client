//
//  SubscribeTableViewController.swift
//  Github
//
//  Created by Nathan on 05/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftDate

class SubscribeTableViewController: UITableViewController{

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor.flatWhite
        self.navigationController?.navigationBar.isTranslucent = true
//        Cache.subscribeCache.set(Cache.subscribeCacheKey, "")
        loadCache()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: - Model
    var subscribeMovements : [[SubscribeModel]] = []
    
    //Mark: -Logic
    func loadCache(){
        // If Empty
        if(Cache.subscribeCache.isEmpty){
            refreshCache()
            return
        }
        
        var subscribeEvents : [SubscribeModel] = []
        subscribeMovements.removeAll()
        
        let value = Cache.subscribeCache.value
        let json = JSON.parse(value)
        
        for event in json{
            var eventString = event.1
            //parse userName
            let userName = eventString["actor"]["login"].stringValue
            let nsUserName = userName as NSString
            let userNameRange = NSMakeRange(0, nsUserName.length)
            
            //parse imageUrl
            let imageUrl = URL(string: eventString["actor"]["avatar_url"].stringValue)
            
            //parse action
            var action : String = ""
            if eventString["payload"]["action"].exists(){
                action = "starred"
            }else if eventString["payload"]["forkee"].exists(){
                action = "forked"
            }
            let nsAction = action as NSString
                        
            //parse repo
            let repoName = eventString["repo"]["name"].stringValue
            let repoUrl = eventString["repo"]["url"].stringValue
            let nsRepoName = repoName as NSString
            let startIndex = nsUserName.length + 2 + nsAction.length
            let repoNameRange = NSMakeRange(startIndex, nsRepoName.length)
            
                        
            //parse Date
            var createdDateString = eventString["created_at"].string!
            createdDateString.remove(at: createdDateString.index(before: createdDateString.endIndex))
            let fromIndex = createdDateString.index(createdDateString.startIndex,offsetBy: 10)
            let toIndex = createdDateString.index(createdDateString.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            createdDateString.replaceSubrange(range, with: " ")
            let createdDate = DateInRegion(string: createdDateString, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
            
            
            //parse ID
            let eventID = eventString["id"].stringValue
            
            //make description
            let description = userName + " " + action + " " + repoName

            let subscribeEvent = SubscribeModel(userName,
                                                action,
                                                createdDate!,
                                                repoName,
                                                repoUrl,
                                                imageUrl!,
                                                description,
                                                eventID,
                                                userNameRange,
                                                repoNameRange
                                                )
            subscribeEvents.append(subscribeEvent)
            }
        subscribeMovements.append(subscribeEvents)
        tableView.reloadData()
        hideProgressDialog()
    }
    
    @IBAction func refreshCache() {
        showProgressDialog()
        Cache.subscribeCache.detailRequest(ApiHelper.currentUser.userName, "received_events") {
            self.loadCache()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subscribeMovements.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeMovements[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Subscribe", for: indexPath)
        let event: SubscribeModel = subscribeMovements[indexPath.section][indexPath.row]
        if let subscribeCell = cell as? SubscribeTableViewCell{
            subscribeCell.subscribeMovement = event
        }
        return cell
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "repoUrl"{
            if let webMVC = destinationViewController as? WebViewController{
                if let cell = sender as? SubscribeTableViewCell{
                    let urlString = ApiHelper.Home_Root + "/" + (cell.subscribeMovement?.repoName)!
                    let url = URL(string: urlString)
                    webMVC.webUrl = url
                    webMVC.navigationItem.title = "Repo Infomation"
                }
            }
        }
    }
    
}
