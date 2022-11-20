//
//  SeSACSearchResultModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/20.
//

import Foundation

struct SeSACSearchResultModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "fromQueueDB": fromQueueDB,
            "fromQueueDBRequested": fromQueueDBRequested,
            "studylist": studylist,
            "reviews" : reviews,
            "reputation" : reputation,
            "uid" : uid,
            "nick" : nick,
            "gender" : gender,
            "type" : type,
            "sesac" : sesac,
            "type" : type,
            "background" : background,
            "lat" : lat,
            "long" : long,
            "fromRecommend": fromRecommend
        ]
        return dictionary
    }
    
    let fromQueueDB: [QueueDB]
    let fromQueueDBRequested: [QueueDBRequested]
    let studylist: [String]
    let reviews: [String]
    let reputation: [String]
    let uid: String
    let nick: String
    let gender: Int
    let type: Int
    let sesac: Int
    let background: Int
    let lat: Double
    let long: Double
    let fromRecommend: [String]
}

struct QueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}

struct QueueDBRequested: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
