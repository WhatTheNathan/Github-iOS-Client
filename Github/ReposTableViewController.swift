//
//  ReposTableViewController.swift
//  Github
//
//  Created by Nathan on 14/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate

class ReposTableViewController: UITableViewController {

    //Mark: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        Cache.reposCache.setKeysuffix(repoOwner + reposType)
        loadCache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.flatBlack
    }
    
    var reposType : String = "repos"
    var repoOwner : String = ApiHelper.currentUser.userName
    
    //Mark : Model
    var reposLists : [[ReposModel]] = []
    
    func loadCache(){
        if(Cache.reposCache.isEmpty){
            refreshCache()
            return
        }
        
        var repoList : [ReposModel] = []
        reposLists.removeAll()
        
        let value = Cache.reposCache.value
        let json = JSON.parse(value)

        for repo in json{
            let repoString = repo.1
            
            //parse repoType
            var repoType : String
            if(repoString["fork"].stringValue == "true"){
                repoType = "fork"
            }else{
                repoType = "create"
            }
            
            //parse repoName
            let repoName = repoString["name"].stringValue
            let repoFullName = repoString["full_name"].stringValue
            
            //parse repoID
            let repoID = repoString["id"].stringValue
            
            //parse repoDescription
            let repoDescription = repoString["description"].stringValue
            
            //parse language
            let language = repoString["language"].stringValue
            
            //parse updatedTime
            var updatedDateString = repoString["updated_at"].stringValue
            updatedDateString.remove(at: updatedDateString.index(before: updatedDateString.endIndex))
            let fromIndex = updatedDateString.index(updatedDateString.startIndex,offsetBy: 10)
            let toIndex = updatedDateString.index(updatedDateString.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            updatedDateString.replaceSubrange(range, with: " ")
            let updatedTime = DateInRegion(string: updatedDateString, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
//            let nowDate = DateInRegion(absoluteDate: Date(), in: Region.Local())
//            print(nowDate)
//            let what = DateTimeInterval(start: updatedTime!.absoluteDate, end: nowDate.absoluteDate)
//            print(what)
//            let diff_in_week = (updatedTime! - nowDate).in(.day)
//            print(diff_in_week!)
            
            
            let repo = ReposModel(repoName,
                                  repoFullName,
                                  repoID,
                                  repoType,
                                  repoDescription,
                                  updatedTime!,
                                  language)
            repoList.append(repo)
        }
        reposLists.append(repoList)
        tableView.reloadData()
        hideProgressDialog()
    }

    @IBAction func refreshCache() {
        showProgressDialog()
        Cache.reposCache.detailRequest(repoOwner,reposType) {
            self.loadCache()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return reposLists.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reposLists[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Repos", for: indexPath)
        let repo = reposLists[indexPath.section][indexPath.row]
        if let repoCell = cell as? ReposTableViewCell{
            repoCell.repo = repo
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination
        if segue.identifier == "repo url"{
            if let webMVC = destinationViewController as? WebViewController{
                if let cell = sender as? ReposTableViewCell{
                    let urlString = ApiHelper.Home_Root + "/" + (cell.repo?.repoFullName)!
                    let url = URL(string: urlString)
                    webMVC.webUrl = url
                    webMVC.navigationItem.title = "Repo Infomation"
                }
            }
        }
    }
}
