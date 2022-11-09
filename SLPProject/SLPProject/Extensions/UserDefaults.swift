//
//  UserDefaults.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "verificationID", defaultValue: "")
    static var userVerificationID: String

    @UserDefault(key: "number", defaultValue: "")
    static var userNumber: String
}
