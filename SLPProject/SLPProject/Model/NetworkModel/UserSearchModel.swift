//
//  UserSearchModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/18.
//

import Foundation

struct UserSearchModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "lat": lat,
            "long": long,
            "studylist": studylist,
        ]
        return dictionary
    }
    
    let lat: Double
    let long: Double
    let studylist: [String]
}
