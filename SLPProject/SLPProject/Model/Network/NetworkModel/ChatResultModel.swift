//
//  ChatResultModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

struct ChatResultModel: Codable {
    let id: String
    let to: String
    let from: String
    let chat: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case to, from, chat, createdAt
    }
}
