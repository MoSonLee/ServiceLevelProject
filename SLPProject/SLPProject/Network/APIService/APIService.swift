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
    
    func studyRequest(dictionary: [String: Any], completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.studyrequest(parameters: dictionary)) { result in
            completion(result)
        }
    }
    
    func responseGetUser(completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.login) { result in
            completion(result)
        }
    }
    
    func withdrawUser(completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.withdraw) { result in
            completion(result)
        }
    }
    
    func requestSearchSeSAC(dictionary: [String: Any], completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.requestSearchSeSAC(parameters: dictionary)) { result in
            completion(result)
        }
    }
    
    func sesacSearch(dictionary: [String: Any], completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.searchSeSAC(parameters: dictionary)) { result in
            completion(result)
        }
    }
    
    func stopSearchSeSAC(completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.stopSearchSeSAC) { result in
            completion(result)
        }
    }
    
    func checkMyQueueState(completion: @escaping  (Result<Response, MoyaError>) -> ()) {
        provider.request(.myQueueState) { result in
            completion(result)
        }
    }
}
