//
//  MyQueueStateModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import Foundation

struct MyQueueStateModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "reviewed": reviewed,
            "matched": matched,
            "dodged": dodged,
            "matchedNick": matchedNick,
            "matchedUid": matchedUid,
        ]
        return dictionary
    }
    let reviewed: Int
    let matched: Int
    let dodged: Int
    let matchedNick: String
    let matchedUid: String
}
