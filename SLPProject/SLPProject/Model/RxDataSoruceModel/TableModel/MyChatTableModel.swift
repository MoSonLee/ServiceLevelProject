//
//  ChatTableModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

import RxDataSources

struct MyChatTableModel {
    var title: String
    var imageString: String
}

struct MyChatTableSectionModel {
    var header: String
    var items: [MyChatTableModel]
}

extension MyChatTableModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}
