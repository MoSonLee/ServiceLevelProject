//
//  SignUpAPI.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/12.
//

import Foundation

import Moya

typealias DictionaryType = [String: Any]

enum SLPTarget {
    case login(parameters: DictionaryType)
    case signUp(parameters: DictionaryType)
    case withdraw(parameters: DictionaryType)
    case update_fcm_token(parameters: DictionaryType)
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
            return "/v1/user"
            
        case .withdraw:
            return "/v1/user/withdraw"
            
        case .update_fcm_token:
            return "v1/user/update_fcm_token"
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
        case .login(let parameters),
                .signUp(let parameters),
                .withdraw(let parameters),
                .update_fcm_token(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "x-api-key": UserDefaults.userToken
        ]
    }
}
