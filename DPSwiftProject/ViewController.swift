//
//  ViewController.swift
//  DPSwiftProject
//
//  Created by dp on 2020/12/22.
//

import UIKit
import SVProgressHUD
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    var mainVC : UIViewController?
    var loginVC : UIViewController?
    
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var testView_WScale: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*
        let view = UIView.init()
        view.backgroundColor = UIColor.green
        self.view.addSubview(view)
        view.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.center.equalTo(self.view)
            ConstraintMaker.width.height.equalTo(222)
        }
        SVProgressHUD.showInfo(withStatus: "1222")
        
        self.testView.layer.masksToBounds = true
        self.testView.layer.cornerRadius = 10;
        self.testView.layer.borderWidth = 1;
        self.testView.layer.borderColor = UIColor.orange.cgColor;
        */
        NotificationCenter.default.addObserver(self, selector: #selector(loginAction), name: NSNotification.Name.init(rawValue: LOGIN_KEY), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logoutAction), name: NSNotification.Name.init(rawValue: LOGOUT_KEY), object: nil)
        
        login(login: false)
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SVProgressHUD.showInfo(withStatus: "加载中...")
//        self.testView_WScale.constant = CGFloat(arc4random() % (UInt32(self.testView.frame.size.width))+22)
    }
    
    /// 登录成功
    /// - Returns: nil
    @objc func loginAction() -> Void {
        login(login: true)
    }
    
    /// 登出成功
    /// - Returns: nil
    @objc func logoutAction() -> Void {
        login(login: false)
    }
    
    /// 控制登录界面显示
    /// - Parameter login: login description
    /// - Returns: description
    func login(login:Bool) -> Void {
        
        if let vc = self.mainVC {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            self.mainVC = nil
        }
        if let vc = self.loginVC {
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            self.loginVC = nil
        }
        
        if login == false {
            
            guard let loginVc = UIStoryboard.storyBdInitial("Login") else {
                print("登录控制器获取失败！")
                return
            }
            let navi = UINavigationController.init(rootViewController: loginVc)
            loginVc.view.backgroundColor = UIColor.randomColor()
            self.view.addSubview(navi.view)
            self.addChild(navi)
            self.loginVC = loginVc
            
        } else
        {
            guard let mainVc = /*UIStoryboard.storyBdInitial("MainTabbar")*/UITabBarController.customIrregularityStyle(delegate: nil) else {
                print("MainTabbar控制器获取失败！")
                return
            }
            self.view.addSubview(mainVc.view)
            self.addChild(mainVc)
            self.mainVC = mainVc;

        }
    }

}

