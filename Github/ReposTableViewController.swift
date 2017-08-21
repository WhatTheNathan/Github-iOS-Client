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
        
//        tableView.estimatedRowHeight = 50
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        Cache.reposCache.setKeysuffix(repoOwner + reposType)
        let seconds = 60 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 60)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
        loadCache()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = UIColor.flatWhite
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func timeChanged() {
        refreshCache()
        // 到下一分钟的剩余秒数，这里虽然接近 60，但是不写死，防止误差累积
        let seconds = 60 - Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 60)
        perform(#selector(self.timeChanged), with: nil, afterDelay: seconds)
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
            var repoDescription = repoString["description"].stringValue
            if repoDescription == ""{
                repoDescription = "No description, website, or topics provided"
            }
            
            //parse language
            let language = repoString["language"].stringValue
            
            //parse starNumber
            let starNumber = repoString["stargazers_count"].stringValue
            
            //parse forkNumber
            let forkNumber = repoString["forks"].stringValue
            
            //parse updatedTime
            var updatedDateString = repoString["updated_at"].stringValue
            updatedDateString.remove(at: updatedDateString.index(before: updatedDateString.endIndex))
            let fromIndex = updatedDateString.index(updatedDateString.startIndex,offsetBy: 10)
            let toIndex = updatedDateString.index(updatedDateString.startIndex,offsetBy: 11)
            let range = fromIndex..<toIndex
            updatedDateString.replaceSubrange(range, with: " ")
            let updatedTime = DateInRegion(string: updatedDateString, format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: Region.Local())
            
            let repo = ReposModel(repoName,
                                  repoFullName,
                                  repoID,
                                  repoType,
                                  repoDescription,
                                  updatedTime!,
                                  language,
                                  starNumber,
                                  forkNumber)
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
        let text = reposLists[indexPath.section][indexPath.row].description
        let desTextAttribute : NSDictionary = [ NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        let nsText = text as NSString
        let option : NSStringDrawingOptions = .usesLineFragmentOrigin
        let size = CGSize(width: 340, height: 0)
        let desTextSize = nsText.boundingRect(with: size, options: option, attributes: desTextAttribute as? [String : Any], context: nil)
//        print(text)
//        print(desTextSize.size.height)
        return desTextSize.size.height + 67
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
