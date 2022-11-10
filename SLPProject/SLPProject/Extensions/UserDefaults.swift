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
    
    @UserDefault(key: "showOnboarding", defaultValue: true)
    static var showOnboarding: Bool
    
    @UserDefault(key: "verificationID", defaultValue: "")
    static var userVerificationID: String
    
    @UserDefault(key: "number", defaultValue: "")
    static var userNumber: String
    
    @UserDefault(key: "userToken", defaultValue: "")
    static var userToken: String
    
    @UserDefault(key: "gender", defaultValue: -1)
    static var gender: Int
}
