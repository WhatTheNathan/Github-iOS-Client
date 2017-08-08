//
//  WebViewController.swift
//  Github
//
//  Created by Nathan on 06/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var webUrl: URL? = nil{
        didSet{
            if webView?.window != nil{
                loadURL()
            }
        }
    }
    
    private func loadURL() {
        if webUrl != nil {
            let request = URLRequest(url: webUrl!)
            spinner.startAnimating()
            webView?.loadRequest(request)
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.delegate = self as? UIWebViewDelegate
        webView?.scalesPageToFit = true
        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIWebView delegate
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activeDownloads += 1
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activeDownloads -= 1
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // Mark: print here
        print("WebView load URL")
        print (request.mainDocumentURL!)
        if let requestURL = request.mainDocumentURL?.absoluteString{
            if (requestURL.contains("https://github.com/?code=")){
                // Mark: print here
                print("oauth Success")
                let index = requestURL.index(requestURL.startIndex,offsetBy: 25)
                let code = requestURL.substring(from: index)
//                if let loginMVC = presentingViewController as? LoginViewController{
//                    loginMVC.code = code
//                }
//                presentingViewController?.dismiss(animated: true)
                ApiHelper.code = code
                self.navigationController?.popViewController(animated: true)
            }
        }
        return true
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
