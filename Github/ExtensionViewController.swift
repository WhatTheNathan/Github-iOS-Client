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
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setBackgroundColor(UIColor.flatBlack)
        SVProgressHUD.setForegroundColor(UIColor.flatWhite)
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
