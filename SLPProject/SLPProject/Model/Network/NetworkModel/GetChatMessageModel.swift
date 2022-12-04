//
//  GetChatMessageModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/04.
//

import Foundation

struct GetChatMessageModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "playload": playload
        ]
        return dictionary
    }
    let playload: [payload]
}

struct payload: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
