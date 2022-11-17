//
//  UserLocationModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/18.
//

import Foundation

struct UserLocationModel: Codable {
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "lat": lat,
            "long": long
        ]
        return dictionary
    }
    
    let lat: Double
    let long: Double
}
