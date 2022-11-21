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
            "fromRecommend": fromRecommend
        ]
        return dictionary
    }
    
    let fromQueueDB: [QueueDB]
    let fromQueueDBRequested: [QueueDB]
    let fromRecommend: [String]
}

struct QueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let studylist, reviews: [String]
    let gender, type, sesac, background: Int
}
