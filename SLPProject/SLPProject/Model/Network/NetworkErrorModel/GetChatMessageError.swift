//
//  GetChatMessageError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/04.
//

import Foundation

enum GetChatMessageError: Int, Error {
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension GetChatMessageError {
    var errorDescription: String {
        switch self {
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
