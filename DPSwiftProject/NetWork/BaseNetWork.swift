//
//  BaseNetWork.swift
//  DPSwiftProject
//
//  Created by dp on 2021/1/6.
//

import Foundation
import Moya
import UIKit
import SwiftyUserDefaults


private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum API_URL {
    case zen
    case userProfile(String)
    case userRepositories(String)
    case joinin([String : String])
    case deviceTime
}

extension API_URL : TargetType {
    var baseURL: URL {
        return URL(string: "http://apiv2.test.nanyouli18.com:18300/")!
    }
    
    var path: String {
        switch self {
        case .zen:
            return "api/zen"
        case .userProfile(let name):
            return "api/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "api/users/\(name.urlEscaped)/repos"
        case .joinin(_):
            return "api/device/joinin"
        case .deviceTime:
            return "api/device/time"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deviceTime, .zen:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .zen:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        case .userRepositories(let name):
            return "[{\"name\": \"\(name)\"}]".data(using: String.Encoding.utf8)!
        case .joinin(_):
            return "".data(using: String.Encoding.utf8)!
        case .deviceTime:
            return "".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        
        switch self {
        case .userRepositories:
            return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        case .joinin(let parameters) :
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
                
        let commonHeaders:[String: String] = ["Accept":"application/mingbox+json; version=1;", "os":"ios", "app-build": Bundle.main.infoDictionary?["CFBundleVersion"] as! String, "device":UIDevice.current.model, "app-version":Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String, "api-version":"20190101", "idfa":UIDevice.current.identifierForVendor?.uuidString ?? "", "device-id":UIDevice.current.identifierForVendor?.uuidString.md5 ?? "", "conn":"WiFi"]
        
        switch self {
        case .joinin(let parameters):
            
            var timeAndS = timeAndSign(params: parameters)

            for (key, value) in commonHeaders {
                timeAndS[key]  = value
            }
            
//            let timeAndS = [
//                "Accept" : "application/xdj+json; version=1;",
//                "api-version" : "20190101",
//                "app-build" : "14883",
//                "app-version" : "8.5.4",
//                "conn" : "WiFi",
//                "device" : "iPhone 7 Plus",
//                "device-id" : "dec1af5dad408e35701eefe68e76a018",
//                "idfa" : "2F8D818D-0757-4669-9F0E-6E8725728371",
//                "os" : "ios",
//                "sign" : "e86d165165ed36a6dcedae76ab018c9c",
//                "time" : "1610692495",
//                "token" : "10118#a55ffcdf-c37d-0f72-44df-c27ec176906c"
//            ]
            
            return timeAndS
        default:
            return commonHeaders
        }
    }
}

func timeAndSign(params:[String: String]) -> [String: String] {
    
    let severInterval = Double(Defaults.timestamp ?? "0") ?? 0
    
    let interval = NSDate().timeIntervalSince1970 + severInterval
    
    
    return [
        "time":"\(interval)",
        "token" : "",
        "sign" : sign(token: "", time: "\(interval)", params: params, needLogin: false)
    ]
}

func sign(token:String, time:String, params:[String:String], needLogin:Bool) -> String {
    
    let totalParms = NSMutableDictionary(dictionary: params)
    totalParms.setValue("\(time)", forKey: "time")
    //签名时 未登录 不需要token
//    if ([MBUser userIsLogin] && needLogin) {
//        totalParams[@"token"] = token;
//    }
    var totalStr = String()
    totalStr.append(API_REQ_KEY)
    
    var allKeys:[String] = []
    
    for item in totalParms.allKeys {
        allKeys.append("\(item)")
    }
    
    allKeys = allKeys.sorted(by: { $0 < $1 })
    
    for item in allKeys {
        totalStr.append(item)
        totalStr.append(totalParms[item] as! String)
    }
    
    
//    if ([MBUser currentUser].salt.length>0 &&[MBUser userIsLogin]&&needLogin) {
//        [totalString appendString:[MBUser currentUser].salt];
//    }
    totalStr = totalStr.md5
    return totalStr
}

fileprivate let API_REQ_KEY = "08bc8ea7fe574ec225435ed45e89ab"

extension Moya.Response {
    func mapNSArray() throws -> Array<Any> {
        let any = try self.mapJSON()
        guard let array = any as? Array<Any> else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
    func mapNSDictionary() throws -> NSDictionary {
        let any = try self.mapJSON()
        guard let dict = any as? NSDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        return dict
    }
}


let apiProvider = MoyaProvider<API_URL>(plugins: [NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))])


                                                                                             
//class BaseNetWork: NSObject {
//
//}
