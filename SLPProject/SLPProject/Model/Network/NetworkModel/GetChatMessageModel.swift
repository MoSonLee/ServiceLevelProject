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
    let playload: [ChatResultModel]
}
