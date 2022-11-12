//
//  UserInfo.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/12.
//

import Foundation

struct UserAccounts: Decodable{
    let userId: String
    let userPhoneNumber: String
    let userEmail: String
    let fcmToken: String
    let nick: String
    let birth: String
    let gender: Int
    let hash: String
}
