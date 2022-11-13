//
//  APIService.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/13.
//

import Foundation

import Moya

final class APIService {
    
    private let provider: MoyaProvider<SLPTarget>
    init() { provider = MoyaProvider<SLPTarget>() }
    
    func requestSignUpUser(dictionary: [String: Any], completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.signUp(parameters: dictionary)) { result in
            completion(result)
        }
    }
    
    func updateFMCtoken(dictionary: [String: Any], completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.update_fcm_token(parmeters: dictionary)) { result in
            completion(result)
        }
    }
}
