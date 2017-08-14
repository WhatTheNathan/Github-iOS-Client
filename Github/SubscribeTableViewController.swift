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
import ChameleonFramework

class SubscribeTableViewController: UITableViewController{

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.flatBlack
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
//        print(Cache.get("subscribe"))
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
            let userName = eventString["actor"]["login"].string!
            
            //parse imageUrl
            let imageUrl = URL(string: eventString["actor"]["avatar_url"].string!)
                        
            //parse repoName
            let repoName = eventString["repo"]["name"].string!
                        
            //parse Date
            var createdDateString = eventString["created_at"].string!
            createdDateString.remove(at: createdDateString.index(before: createdDateString.endIndex))
            let fromIndex = createdDateString.index(createdDateString.startIndex,offsetBy: 10)
            let toIndex = createdDateString.index(createdDateString.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            createdDateString.replaceSubrange(range, with: " ")
            let createdDate = try! DateInRegion(string: createdDateString, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
                        
            //parse action
            var action : String = ""
            if eventString["payload"]["action"].exists(){
                action = "starred"
            }else{
                action = "forked"
            }
            
            //parse ID
            let eventID = eventString["id"].stringValue
            
            //make description
            let description = userName + " " + action + " " + repoName

            let subscribeEvent = SubscribeModel(userName,
                                                action,
                                                (createdDate?.absoluteDate)!,
                                                repoName,
                                                imageUrl!,
                                                description,
                                                eventID)
            subscribeEvents.append(subscribeEvent)
            }
        subscribeMovements.append(subscribeEvents)
        hideProgressDialog()
        tableView.reloadData()
    }
    
    @IBAction func refreshCache() {
        showProgressDialog()
        //Fix: create closure to make request
        Cache.subscribeCache.subscribeRequest(ApiHelper.currentUser.userName, "received_events") {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
