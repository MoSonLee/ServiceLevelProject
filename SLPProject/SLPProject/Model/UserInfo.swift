//
//  UserInfo.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/12.
//

import Foundation

struct UserAccounts: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "phoneNumber": phoneNumber,
            "FCMtoken": FCMtoken,
            "nick": nick,
            "birth": birth,
            "email": email,
            "gender": gender,
        ]
        return dictionary
    }
    
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
}

struct UserFCMtoken: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [ "FCMtoken": FCMtoken ]
        return dictionary
    }
    
    let FCMtoken: String
}
