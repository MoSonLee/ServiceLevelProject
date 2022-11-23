//
//  SearchCollecionModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/23.
//


import Foundation

import RxDataSources

struct SearchCollecionModel {
    var title: String
}

struct SearchCollecionSectionModel {
    var header: String
    var items: [SearchCollecionModel]
}

extension SearchCollecionModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}

extension SearchCollecionSectionModel: AnimatableSectionModelType {
    typealias Item = SearchCollecionModel
    typealias Identity = String
    var identity: String {
        return header
    }
    
    init(original: SearchCollecionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
