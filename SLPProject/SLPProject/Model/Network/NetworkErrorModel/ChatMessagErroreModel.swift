//
//  ChatMessagErroreModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

enum ChatMessagErroreModel: Int, Error {
    case sendChatFailure = 201
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension ChatMessagErroreModel {
    var errorDescription: String {
        switch self {
        case .sendChatFailure:
            return "201: sendChatFailure"
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
