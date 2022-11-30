//
//  StopSearchError.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import Foundation

enum StopSearchError: Int, Error {
    case alearyStoppedError = 201
    case tokenError = 401
    case unregistered = 406
    case serverError = 500
    case clientError = 501
    case unknown
    
    var description: String { self.errorDescription }
}

extension StopSearchError {
    var errorDescription: String {
        switch self {
        case .alearyStoppedError:
            return "201: alearyStoppedError"
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

