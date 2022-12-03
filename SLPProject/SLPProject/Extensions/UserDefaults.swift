//
//  UserDefaults.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

@propertyWrapper
struct UserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(Value.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}

extension UserDefaults {
    
    @UserDefault(key: "showOnboarding", defaultValue: true)
    static var showOnboarding: Bool
    
    @UserDefault(key: "verificationID", defaultValue: "")
    static var userVerificationID: String
    
    @UserDefault(key: "fcmToken", defaultValue: "")
    static var fcmToken: String
    
    @UserDefault(key: "number", defaultValue: "")
    static var userNumber: String
    
    @UserDefault(key: "userToken", defaultValue: "")
    static var userToken: String
    
    @UserDefault(key: "nick", defaultValue: "")
    static var nick: String
    
    @UserDefault(key: "birth", defaultValue: "")
    static var birth: String
    
    @UserDefault(key: "email", defaultValue: "")
    static var userEmail: String
    
    @UserDefault(key: "gender", defaultValue: -1)
    static var gender: Int
    
    @UserDefault(key: "verfied", defaultValue: false)
    static var verified: Bool
    
    @UserDefault(key: "homeTabMode", defaultValue: HomeTabMode.search)
    static var homeTabMode: HomeTabMode
    
    @UserDefault(key: "matchedUID", defaultValue: "")
    static var matchedUID: String
    
    @UserDefault(key: "userId", defaultValue: "")
    static var userId: String
}
