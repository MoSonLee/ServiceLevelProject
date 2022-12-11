//
//  RealmRepository.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/06.
//

import Foundation

import RealmSwift

final class RealmRepository {
    
    let key = Data(count: 64)
    lazy var config = Realm.Configuration(encryptionKey: key)
    lazy var realm = try! Realm(configuration: config)
    
    func create(chat: Chat) {
        do {
            try realm.write  {
                realm.add(chat)
            }
        } catch _ {
            print("ERROR")
        }
    }
    
    func fetch(id: String, myId: String) -> [Chat] {
        return Array(realm.objects(Chat.self)
            .filter("id == %@ || id == %@", id, myId)
            .sorted(byKeyPath: "chatDate", ascending: true))
    }
}
