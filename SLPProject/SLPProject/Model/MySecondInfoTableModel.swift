//
//  MySecondInfoTableModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/16.
//

import Foundation

import RxDataSources

struct MySecondInfoTableModel {
    var title: String?
    var gender: Int?
    var study: String?
    var switchType: Bool?
    var age: String?
    var slider: String?
}

struct MySecondInfoTableSectionModel {
    var header: String
    var items: [MySecondInfoTableModel]
}

extension MySecondInfoTableModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}

extension MySecondInfoTableSectionModel: AnimatableSectionModelType {
    typealias Item = MySecondInfoTableModel
    typealias Identity = String
    var identity: String {
        return header
    }
    
    init(original: MySecondInfoTableSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
