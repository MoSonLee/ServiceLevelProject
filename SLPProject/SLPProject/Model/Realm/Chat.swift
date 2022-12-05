//
//  Chat.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/06.
//

import Foundation

import RealmSwift

final class Chat: Object {
    
    @Persisted var chat: String
    @Persisted var chatDate: String
    @Persisted var id: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(chat: String, chatDate: String, id: String) {
        self.init()
        self.chat = chat
        self.chatDate = chatDate
        self.id = id
    }
}
