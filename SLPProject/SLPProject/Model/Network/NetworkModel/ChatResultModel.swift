//
//  ChatResultModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

struct ChatResultModel: Codable {
    var ChatResultModel: [String: Any] {
        let dictionary: [String: Any] = [
            "_id": id,
            "to": to,
            "from": from,
            "chat": chat,
            "createdAt": createdAt
            
        ]
        return dictionary
    }
    let id: String
    let to: String
    let from: String
    let chat: String
    let createdAt: String
}
