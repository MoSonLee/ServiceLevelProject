//
//  WithdrawError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/12.
//

import Foundation

enum SLPWithdrawError: Int, Error {
    case tokenError = 401
    case unRegisteredUser = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension SLPWithdrawError {
    var errorDescription: String {
        switch self {
        case .tokenError:
            return "401: tokenError"
        case .unRegisteredUser:
            return "406: unRegisteredUser"
        case .serverError:
            return "500: serverError"
        case .clientError:
            return "501: clinetError"
        case .unknown:
            return "UnKnown Error"
        }
    }
}
