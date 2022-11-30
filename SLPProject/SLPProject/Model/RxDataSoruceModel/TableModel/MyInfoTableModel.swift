//
//  MyInfoTableModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import Foundation

import RxDataSources

struct MyInfoTableModel {
    var buttonImageString: String
    var title: String
}

struct MyInfoTableSectionModel {
    var header: String
    var items: [MyInfoTableModel]
}

extension MyInfoTableModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}

extension MyInfoTableSectionModel: AnimatableSectionModelType {
    typealias Item = MyInfoTableModel
    typealias Identity = String
    var identity: String {
        return header
    }
    
    init(original: MyInfoTableSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
