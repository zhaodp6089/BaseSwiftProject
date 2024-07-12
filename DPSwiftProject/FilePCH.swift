//
//  FilePCH.swift
//  DPSwiftProject
//
//  Created by dp on 2021/1/6.
//

import UIKit
import SwiftyUserDefaults


extension DefaultsKeys {
    
    var timestamp: DefaultsKey<String?> { .init("timestamp_Key") }

    
}

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let fullScreen = ((UIApplication.shared.windows.filter({$0.isKeyWindow}).last != nil) && UIApplication.shared.windows.filter({$0.isKeyWindow}).last?.safeAreaInsets.left ?? 0 > 0 && UIApplication.shared.windows.filter({$0.isKeyWindow}).last?.safeAreaInsets.bottom ?? 0 > 0)
var isFullScreen: Bool {
    if #available(iOS 11, *) {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last else {
            return false
        }
        
        if window.safeAreaInsets.left > 0 || window.safeAreaInsets.bottom > 0 {
            print(window.safeAreaInsets)
            return true
        }
    }
    return false
}

let safeA = UIApplication.shared.windows.filter({$0.isKeyWindow}).last?.safeAreaInsets
var safeArea: UIEdgeInsets {
    guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).last else {
        return .zero
    }
    return window.safeAreaInsets
}

/// 状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height;

/// 导航栏高度
let navigationHeight = (statusBarHeight + 44)

/// tabbar高度
let tabBarHeight = (49 + safeArea.bottom)

///顶部的安全距离
let topSafeAreaHeight = (safeArea.top)

///底部的安全距离
let bottomSafeAreaHeight = (safeArea.bottom)


var allowRotation = false

func allowInterfaceOrientation(_ orientation:UIInterfaceOrientation, allow:Bool) {
    allowRotation = allow
    let value = orientation.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
}

var timestamp = ""


let LOGIN_KEY = "loginIN"
let LOGOUT_KEY = "loginOUT"

