//
//  NearSeSACTableModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/26.
//

import Foundation

import RxDataSources

struct NearSeSACTableModel {
    var backGroundImage: Int
    var title: String
    var reputation: [Int]
    var studyList: [String]
    var review: [String]
}

struct NearSeSACTableSectionModel {
    var header: String
    var items: [NearSeSACTableModel]
}

extension NearSeSACTableModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}

extension NearSeSACTableSectionModel: AnimatableSectionModelType {
    typealias Item = NearSeSACTableModel
    typealias Identity = String
    var identity: String {
        return header
    }
    
    init(original: NearSeSACTableSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
