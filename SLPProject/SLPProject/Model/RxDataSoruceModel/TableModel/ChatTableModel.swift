//
//  ChatTableModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

import RxDataSources

struct ChatTableModel {
    var title: String
    var userId: String
}

extension ChatTableModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}

struct ChatTableSectionModel {
    var header: String
    var items: [ChatTableModel]
}

extension ChatTableSectionModel: AnimatableSectionModelType {
    typealias Item = ChatTableModel
    typealias Identity = String
    var identity: String {
        return header
    }
    
    init(original: ChatTableSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
