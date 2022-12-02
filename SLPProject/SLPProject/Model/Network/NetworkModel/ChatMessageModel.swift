//
//  ChatModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

struct ChatMessageModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "chat": chat
        ]
        return dictionary
    }
    let chat: String
}
