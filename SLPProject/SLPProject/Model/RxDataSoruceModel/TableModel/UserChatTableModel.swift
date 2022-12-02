//
//  UserChatTableModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

import RxDataSources

struct UserChatTableModel {
    var title: String
    var imageString: String
}

struct UserChatTableSectionModel {
    var header: String
    var items: [UserChatTableModel]
}

extension UserChatTableModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}
