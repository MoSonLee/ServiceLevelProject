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
    case update_fcm_token
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .get
            
        case .signUp, .withdraw:
            return .post
            
        case .update_fcm_token:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login, .withdraw, .update_fcm_token:
            return .requestPlain
        case .signUp(let parameters):
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
