//
//  FirebaseAuthorization.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/11.
//

import Foundation

import FirebaseAuth

final class FirebaseAuthorization {
    func getCertificationMessage(phoneNumber: String, completion: @escaping (String?, Error?) -> ()) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let id = verificationID {
                    completion(id, nil)
                }
                if let error = error {
                    completion(nil, error)
                }
            }
    }
    
    func verificationButtonClicked(code: String?, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        let verificationID = UserDefaults.userVerificationID
        guard let verificationCode = code else { return  }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential) {  authResult, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
            } else {
                completion(authResult, nil)
            }
        }
    }
    
    func getToken(completion: @escaping (String?, Error?) -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                completion(nil, error)
                return
            } else {
                completion(idToken, error)
            }
        }
    }
}
