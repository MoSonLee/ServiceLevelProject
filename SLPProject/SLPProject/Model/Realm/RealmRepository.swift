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
    
    func fetch(id: String) -> Results<Chat>! {
        return realm.objects(Chat.self)
            .filter("id == %@", id)
            .sorted(byKeyPath: "chatDate", ascending: false)
    }
}
