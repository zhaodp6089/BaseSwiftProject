//
//  LoginVC.swift
//  DPSwiftProject
//
//  Created by dp on 2020/12/31.
//

import Foundation
import UIKit
import SwiftyUserDefaults
import Alamofire

class LoginVC: UIViewController {
    
    var data:Data?
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        //        ["device_id" : "42F3AAAA-8624-493E-83B9-0A4A1E570648", "mac" : "ACBC32816953"]
        
        if isFullScreen {
            
        }
        
        let cancel = apiProvider.request(.deviceTime, completion: { result in
            switch result {
            case let .success(response):
                _ = response.statusCode // 响应状态码：200, 401, 500...
                self.data = response.data // 响应数据
                print(self.data ?? "")
                
                var string:NSDictionary?
                
                do {
                    try string = response.mapNSDictionary()
                } catch {
                    string = ["ero":"12"]
                }
                
//                let data = string?["data"] as! NSDictionary
                
//                if let timstp = data["timestamp"] {
//                    Defaults.timestamp = "\(timstp)"
//                    
//                    apiProvider.request(.joinin(["device_id" : "42F3AAAA-8624-493E-83B9-0A4A1E570648", "mac" : "ACBC32816953"])) { resultJoin in
//                        
//                        switch resultJoin {
//                        case let .success(responseJoin):
//                            var dict:NSDictionary?
//                            
//                            do {
//                                try dict = responseJoin.mapNSDictionary()
//                            } catch {
//                                dict = ["ero":"12"]
//                            }
//                            
//                            UIAlertController.alertMessage(style: .alert, title: "deviceJoin", message:dict?.description ?? "", options: [], cancel: "ok")
//                            
//                        case .failure(_):
//                            break
//                        }
//                        
//                    }
//                    
//                }
                
                UIAlertController.alertMessage(style: .alert, title: "deviceTime", message:Defaults.timestamp ?? "", options: [], cancel: "ok")
            case .failure(_):
                
                break
            }
        })
        cancel.cancel()
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGIN_KEY), object: nil)
    }
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(#function) in \(#file) 已释放")
    }
    
}
