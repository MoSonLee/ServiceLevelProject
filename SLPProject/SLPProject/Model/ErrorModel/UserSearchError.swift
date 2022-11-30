//
//  UserSearchError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/25.
//

import Foundation

enum UserSearchError: Int, Error {
    case reported3 = 201
    case cancelOnce = 203
    case cancelTwo = 204
    case cancelThree = 205
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension UserSearchError {
    var errorDescription: String {
        switch self {
        case .reported3:
            return "201: notRequestYet"
        case .cancelOnce:
            return  "203: cancelOnce"
        case .cancelTwo:
            return  "204: cancelTwo"
        case .cancelThree:
            return  "205: cancelThree"
        case .tokenError:
            return "401: tokenError"
        case .unregistered:
            return "406: unRegisteredUser"
        case .serverError:
            return "500: serverError"
        case .clientError:
            return "501: clientError"
        case .unknown:
            return "UnKnown Error"
        }
    }
}
