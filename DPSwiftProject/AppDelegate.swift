//
//  AppDelegate.swift
//  DPSwiftProject
//
//  Created by dp on 2020/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        self.window = UIWindow.init(windowScene: UIWindowScene.init(session: connectingSceneSession, connectionOptions: options));
        
        // MARK:如果还想再此函数中初始化window要保证info.plist中没有以下内容(使用iOS13以前的创建方式不使用SceneDelegate管理视图)
        /*
        <key>UIApplicationSceneManifest</key>
        <dict>
            <key>UIApplicationSupportsMultipleScenes</key>
            <false/>
            <key>UISceneConfigurations</key>
            <dict>
                <key>UIWindowSceneSessionRoleApplication</key>
                <array>
                    <dict>
                        <key>UISceneConfigurationName</key>
                        <string>Default Configuration</string>
                        <key>UISceneDelegateClassName</key>
                        <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
                        <key>UISceneStoryboardFile</key>
                        <string>Main</string>
                    </dict>
                </array>
            </dict>
        </dict>
 */
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white;
        self.window?.rootViewController = UIStoryboard.storyBdInitial("Main")
        self.window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
/*
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
     self.window = UIWindow.init(windowScene: UIWindowScene.init(session: connectingSceneSession, connectionOptions: options));
     self.window?.backgroundColor = UIColor.white;
     self.window?.rootViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
     self.window?.makeKeyAndVisible()
     
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
*/

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation {
            return UIInterfaceOrientationMask.all
        }
        return UIInterfaceOrientationMask.portrait
    }
    
}

