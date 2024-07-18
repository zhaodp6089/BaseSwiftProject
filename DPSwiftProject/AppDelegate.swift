//
//  AppDelegate.swift
//  DPSwiftProject
//
//  Created by dp on 2020/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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
        makeKeyWindow(scene: nil)
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation {
            return UIInterfaceOrientationMask.all
        }
        return UIInterfaceOrientationMask.portrait
    }
    
}

