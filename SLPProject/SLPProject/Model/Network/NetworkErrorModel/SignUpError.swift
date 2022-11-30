//
//  SignUpError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/12.
//

import Foundation

enum SLPSignUpError: Int, Error {
    case registeredUser = 201
    case invalidateNickname = 202
    case tokenError = 401
    case unRegisteredUser = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension SLPSignUpError {
    var errorDescription: String {
        switch self {
        case .registeredUser:
            return "200: registeredUser"
        case .invalidateNickname:
            return "201: invalidateNickname"
        case .tokenError:
            return "401: tokenError"
        case .unRegisteredUser:
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
