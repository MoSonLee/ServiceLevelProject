//
//  SLPTarget.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/12.
//

import Foundation

import Moya

typealias DictionaryType = [String: Any]

enum SLPTarget {
    case login
    case signUp(parameters: DictionaryType)
    case withdraw
    case update_fcm_token(parmeters: DictionaryType)
    case requestSearchSeSAC(parameters: DictionaryType)
    case stopSearchSeSAC
    case searchSeSAC(parameters: DictionaryType)
    case myQueueState
}

extension SLPTarget: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: APIURL.url) else {
            fatalError("fatal error -invalid api url")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .login, .signUp:
            return "/user"
            
        case .withdraw:
            return "/user/withdraw"
            
        case .update_fcm_token:
            return "/user/update_fcm_token"
            
        case .requestSearchSeSAC, .stopSearchSeSAC:
            return "/queue"
            
        case .searchSeSAC:
            return "/queue/search"
            
        case .myQueueState:
            return "/queue/myQueueState"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .myQueueState:
            return .get
            
        case .signUp, .withdraw, .searchSeSAC, .requestSearchSeSAC:
            return .post
            
        case .update_fcm_token:
            return .put
            
        case .stopSearchSeSAC:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login, .withdraw, .stopSearchSeSAC, .myQueueState:
            return .requestPlain
            
        case .signUp(let parameters), .update_fcm_token(let parameters), .requestSearchSeSAC(let parameters), .searchSeSAC(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var validationType: ValidationType {
        return .customCodes([200])
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.userToken
        ]
    }
}
