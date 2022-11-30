//
//  StudyRequestError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import Foundation

enum StudyRequestError: Int, Error {
    case alreadyRequested = 201
    case alreayCanceled = 202
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension StudyRequestError {
    var errorDescription: String {
        switch self {
        case .alreadyRequested:
            return "201: userAlreadyMatched"
        case .alreayCanceled:
            return  "202: userCanceledStudy"
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
