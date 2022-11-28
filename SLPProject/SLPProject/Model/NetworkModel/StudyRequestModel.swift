//
//  StudyRequestModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/29.
//

import Foundation

struct StudyRequestModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "otheruid": otheruid
        ]
        return dictionary
    }
    
    let otheruid: String
}
