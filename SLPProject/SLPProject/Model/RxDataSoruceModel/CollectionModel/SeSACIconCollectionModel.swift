//
//  SeSACIconCollectionModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/03.
//

import Foundation

import RxDataSources

struct SeSACIconCollectionModel {
    var imageString: String
    var titleText: String
    var descriptionText: String
}

struct SeSACIconCollectionSectionModel {
    var header: String
    var items: [SeSACIconCollectionModel]
}

extension SeSACIconCollectionModel: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return UUID().uuidString
    }
}

extension SeSACIconCollectionSectionModel: AnimatableSectionModelType {
    typealias Item = SeSACIconCollectionModel
    typealias Identity = String
    var identity: String {
        return header
    }
    
    init(original: SeSACIconCollectionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
