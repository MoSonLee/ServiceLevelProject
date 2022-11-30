//
//  StudyAcceptError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import Foundation

enum StudyAcceptError: Int, Error {
    case userAlreadyMatched = 201
    case userCanceledStudy = 202
    case alreadyMatched = 203
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension StudyAcceptError {
    var errorDescription: String {
        switch self {
        case .userAlreadyMatched:
            return "201: userAlreadyMatched"
        case .userCanceledStudy:
            return  "202: userCanceledStudy"
        case .alreadyMatched:
            return  "204: alreadyMatched"
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
