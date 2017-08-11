//
//  ExtensionViewController.swift
//  Github
//
//  Created by Nathan on 05/08/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import SVProgressHUD

private var _progressDialogShown = false

extension UIViewController{
    
    static var progressDialogShown : Bool {
        get {
            return _progressDialogShown
        } set {
            _progressDialogShown = newValue
        }
    }
    
    /// 显示加载框（全局单例）
    static func showProgressDialog() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.show()
        progressDialogShown = true
    }
    
    func showProgressDialog() {
        UIViewController.showProgressDialog()
    }
    
    /// 隐藏加载框（全局单例）
    static func hideProgressDialog() {
        SVProgressHUD.dismiss()
        progressDialogShown = false
    }
    
    func hideProgressDialog() {
        UIViewController.hideProgressDialog()
    }
}
