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

class SubscribeTableViewController: UITableViewController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        loadCache(completionHandler: completionHandler)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Mark: - Model
    var subscribeMovements : [[SubscribeModel]] = []
    
    //Mark: -Logic
    private func loadCache(completionHandler: @escaping () -> ()){
        Alamofire.request(ApiHelper.API_Root+"/users/" + "22Nathan" + "/received_events").responseJSON {response in
            switch response.result.isSuccess {
            case true:
                var subscribeEvents : [SubscribeModel] = []
                if let value = response.result.value {
                    let json = JSON(value)
                    for event in json{
                        var eventString = event.1
                        let subscribeEvent = SubscribeModel(eventString["actor"]["login"].string!,
                                                            "",
                                                            eventString["created_at"].string!,
                                                            eventString["repo"]["name"].string!,
                                                            eventString["actor"]["avatar_url"].string!,
                                                            "")
                        subscribeEvents.append(subscribeEvent)
                    }
                }
                self.subscribeMovements.append(subscribeEvents)
                completionHandler()
            case false:
                print(response.result.error!)
            }
        }
    }
    
    private func completionHandler(){
        print(subscribeMovements[0][0].userName)
        tableView.reloadData()
    }
    
    @IBAction func refreshCache(sender: UIRefreshControl) {
        
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return subscribeMovements.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeMovements[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("dsfdsfrwfrrws")
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
