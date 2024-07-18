//
//  Tool.swift
//  DPSwiftProject
//
//  Created by dp on 2020/12/29.
//

import Foundation
import UIKit
import ESTabBarController_swift
import Hue

import CommonCrypto


func makeKeyWindow(scene : NSObject?) {
    if #available(iOS 13.0, *) {
        if let sc = scene as? UIWindowScene {
            rtWindow = UIWindow(windowScene: sc)
        }
    } else {
        // Fallback on earlier versions
        rtWindow = UIWindow.init(frame: UIScreen.main.bounds)
    }
    rtWindow?.backgroundColor = UIColor.white;
    rtWindow?.rootViewController = UITabBarController.customIrregularityStyle(delegate: nil)
    rtWindow?.makeKeyAndVisible()
}

var rtWindow: UIWindow?

//var dpWindow: UIWindow {
//    if let window: UIWindow = (UIApplication.shared.delegate?.window)! {
//        return window
//    } else {
//        if #available(iOS 13.0, *) {
//            let arr: Set = UIApplication.shared.connectedScenes
//            let windowScene: UIWindowScene = arr.first as! UIWindowScene
//        //如果是普通APP开发，可以使用
//        // SceneDelegate * delegate = (SceneDelegate *)windowScene.delegate;
//           //UIWindow * mainWindow = delegate.window;
//         if let mainWindow: UIWindow = windowScene.value(forKeyPath: "delegate.window") as? UIWindow {
//                return mainWindow
//            } else {
//                return UIApplication.shared.windows.first!
//            }
//        }else{
//            return UIApplication.shared.keyWindow!
//        }
//    }
//}

extension String {
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }
}

extension UIImage {
    class func creatImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIStoryboard {
    
    class func storyBdInitial(_ storyName:String) -> UIViewController? {
        
        let vc = UIStoryboard.init(name: storyName, bundle: Bundle.main).instantiateInitialViewController()
        return vc
    }
    
    class func stBdWithID(storyName:String, nameID:String?) -> UIViewController {
        guard let _ = nameID?.isEmpty else {
            return UIStoryboard.init(name: storyName, bundle: Bundle.main).instantiateInitialViewController() ?? UIViewController()
        }
        return UIStoryboard.init(name: storyName, bundle: Bundle.main).instantiateViewController(withIdentifier: nameID!)
    }
    
}

extension UIViewController {
    
    class func currentTopViewController(base: UIViewController? = rtWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return currentTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return currentTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return currentTopViewController(base: presented)
        }
        return base
    }
    
    class func alertMessage(style:UIAlertController.Style, title:String, message:String, options:[String], cancel:String?, targetVC:UIViewController?) -> Void {
        
        let currentVc = targetVC ?? UIViewController.currentTopViewController()
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: style)
        for str in options {
            alertVC.addAction(UIAlertAction(title: str, style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
        }
        alertVC.addAction(UIAlertAction(title: cancel ?? "取消", style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertVC.popoverPresentationController?.sourceRect = currentVc?.view.bounds ?? CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            alertVC.popoverPresentationController?.sourceView = currentVc?.view
        }
        
        currentVc?.present(alertVC, animated: true, completion: nil)
    }
    
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
    }
    
}

extension UITabBarController {
    class func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> ESTabBarController? {
        
        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        //        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        //        tabBarController.tabBar.backgroundImage = NSObject.creatImageWithColor(color: UIColor.randomColor())
        
        var vcArr:[UIViewController] = []
        
        if let v1 = UIStoryboard.storyBdInitial("IMModule") {
            v1.tabBarItem = ESTabBarItem.init(EBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
            vcArr.append(UINavigationController.init(rootViewController: v1))
        }
        let v2 = UIViewController()
        v2.tabBarItem = ESTabBarItem.init(EBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        vcArr.append(UINavigationController.init(rootViewController: v2))
        
        let v3 = UIViewController()
        let bigBarV = EBasicContentView.init(irregularity: true, animEnable: true)
        v3.tabBarItem = ESTabBarItem.init(bigBarV, title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        vcArr.append(UINavigationController.init(rootViewController: v3))
        
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    alertController.popoverPresentationController?.sourceRect = bigBarV.bounds
                    alertController.popoverPresentationController?.sourceView = bigBarV
                }
                tabBarController?.present(alertController, animated: true, completion: nil)
                
            }
        }
        
        let v4 = UIStoryboard.stBdWithID(storyName: "Main", nameID: "otherV")
        v4.tabBarItem = ESTabBarItem.init(EBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        vcArr.append(UINavigationController.init(rootViewController: v4))
        
        //        if let v5 = UIStoryboard.storyBdInitial("MyProfile") {
        //            v5.tabBarItem = ESTabBarItem.init(EBasicContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        //            vcArr.append(UINavigationController.init(rootViewController: v5))
        //        }
        
        if let v5 = UIStoryboard.storyBdInitial("MyProfile") {
            let tabbarV = EBasicContentView()
            tabbarV.animationAble = true
            v5.tabBarItem = ESTabBarItem.init(tabbarV, title: "Favor2", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
            vcArr.append(UINavigationController.init(rootViewController: v5))
        }
        
        tabBarController.viewControllers = vcArr
        
        //        let navigationController = UINavigationController.init(rootViewController: tabBarController)
        //        tabBarController.title = "Example"
        return tabBarController
    }
}

// MARK:自定义tabbar
class EBasicContentView: ESTabBarItemContentView {
    
    public var duration = 0.3
    
    public var animationAble = false
    
    public var irregularity:Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .gray
        highlightTextColor = .blue
        iconColor = .gray
        highlightIconColor = .blue
    }
    
    init(irregularity:Bool, animEnable:Bool) {
        self.init()
        self.irregularity = irregularity
        self.animationAble = animEnable
        
        self.imageView.backgroundColor = UIColor.init(red: 23/255.0, green: 149/255.0, blue: 158/255.0, alpha: 1.0)
        self.imageView.layer.borderWidth = 3.0
        self.imageView.layer.borderColor = UIColor.init(white: 235 / 255.0, alpha: 1.0).cgColor
        self.imageView.layer.cornerRadius = 35
        self.insets = UIEdgeInsets.init(top: -11, left: 0, bottom: 0, right: 0)
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        self.superview?.bringSubviewToFront(self)
        
        textColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(white: 255.0 / 255.0, alpha: 1.0)
        backdropColor = .clear
        highlightBackdropColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        if irregularity == true {
            self.imageView.sizeToFit()
            self.imageView.center = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        }
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        if animationAble { self.bounceAnimation() }
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        if animationAble { self.bounceAnimation() }
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    
}
