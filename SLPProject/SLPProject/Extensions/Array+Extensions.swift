//
//  Array+Extensions.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/25.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
