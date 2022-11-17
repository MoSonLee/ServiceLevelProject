//
//  QueueStateError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/18.
//

import Foundation

enum QueueStateError: Int, Error {
    case notRequestYet = 201
    case tokenError = 401
    case unregisteredError = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension QueueStateError {
    var errorDescription: String {
        switch self {
        case .notRequestYet:
            return  "201: notRequestYet"
        case .tokenError:
            return "401: tokenError"
        case .unregisteredError:
            return "406: unRegisteredUser"
        case .serverError:
            return "500: serverError"
        case .unknown:
            return "UnKnown Error"
        case .clientError:
            return "501: clientError"
        }
    }
}
