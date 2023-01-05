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
    case studyrequest(parameters: DictionaryType)
    case studyaccept(parameters: DictionaryType)
    case getChatMessage(id: String, date: String)
    case sendChatMessage(parameters: DictionaryType, id: String)
    case dodgeStudy(parameters: DictionaryType)
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
            return "/v1/user/update_fcm_token"
            
        case .requestSearchSeSAC, .stopSearchSeSAC:
            return "/v1/queue"
            
        case .searchSeSAC:
            return "/v1/queue/search"
            
        case .myQueueState:
            return "/v1/queue/myQueueState"
            
        case .studyrequest:
            return "/v1/queue/studyrequest"
            
        case .studyaccept:
            return "/v1/queue/studyaccept"
            
        case .sendChatMessage(_, let id):
            return "/v1/chat/\(id)"
            
        case .getChatMessage(let id, _):
            return "/v1/chat/\(id)"
            
        case .dodgeStudy(parameters: _):
            return "/v1/queue/dodge"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .myQueueState, .getChatMessage:
            return .get
            
        case .signUp, .withdraw, .searchSeSAC, .requestSearchSeSAC, .studyrequest, .studyaccept, .sendChatMessage, .dodgeStudy:
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
            
        case .signUp(let parameters), .update_fcm_token(let parameters), .searchSeSAC(let parameters), .studyrequest(let parameters), .studyaccept(let parameters), .sendChatMessage(let parameters, _), .dodgeStudy(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .requestSearchSeSAC(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding(arrayEncoding: .noBrackets))
            
        case .getChatMessage(_, let date):
            return .requestParameters(parameters: ["lastchatDate": date], encoding: URLEncoding.queryString)
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
