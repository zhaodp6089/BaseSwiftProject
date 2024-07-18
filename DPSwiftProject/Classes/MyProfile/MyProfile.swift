//
//  MyProfile.swift
//  DPSwiftProject
//
//  Created by dp on 2021/1/6.
//

import Foundation
import UIKit

class MyProfile: UIViewController {
    
    var rotation = false
    
    
    override func viewDidLoad() {
//        allowInterfaceOrientation(.portrait, allow: true)
        if isFullScreen {
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        allowInterfaceOrientation(.landscapeRight, allow: allowRotation)
    }
    
    @IBAction func logOutAction(_ sender: UIButton) {
        loginAction()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LOGOUT_KEY), object: nil)
//        if rotation {
////            portraitInterface()
//            allowInterfaceOrientation(.portrait, allow: true)
//        } else {
////            leftInterface()
//            allowInterfaceOrientation(.landscapeRight, allow: true)
//        }
//        rotation = !rotation
    }
    
    func loginAction() {
        guard let loginVc = UIStoryboard.storyBdInitial("Login") else {
            print("登录控制器获取失败！")
            return
        }
        let navi = UINavigationController.init(rootViewController: loginVc)
        loginVc.view.backgroundColor = UIColor.randomColor()
        self.present(navi, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(#function) in \(#file) 已释放")
    }
    
}


