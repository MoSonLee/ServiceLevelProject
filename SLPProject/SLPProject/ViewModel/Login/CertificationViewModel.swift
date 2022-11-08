//
//  CertificationViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/08.
//

import Foundation

import FirebaseAuth
import RxCocoa
import RxSwift

final class CertificationViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let certificationTextFieldCompleted: Signal<String>
        let startButtonTapped: Signal<String>
        let resendButtonTapped: Signal<Void>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let popVC: Signal<Void>
        let ableStartButton: Signal<Bool>
        let showSingUpVC: Signal<Void>
        let showMainVC: Signal<Void>
        let resendCode: Signal<Void>
        let showToast: Signal<String>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let popVCRealy = PublishRelay<Void>()
    private let ableStartButtonRelay = PublishRelay<Bool>()
    private let showSingUpVCRelay = PublishRelay<Void>()
    private let showMainVCRelay = PublishRelay<Void>()
    private let resendCodeRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.showToastRelay.accept(SLPAssets.RawString.loginSecondaryText.text)
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRealy.accept(())
            })
            .disposed(by: disposeBag)
        
        input.certificationTextFieldCompleted
            .emit(onNext: { [weak self] text in
                if text.count == 6 {
                    self?.ableStartButtonRelay.accept(true)
                } else {
                    self?.ableStartButtonRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.startButtonTapped
            .emit(onNext: { [weak self] text in
                self?.verificationButtonClicked(code: text)
            })
            .disposed(by: disposeBag)
        
        input.resendButtonTapped
            .emit(onNext: { [weak self] _ in
                guard let phoneNumber =  UserDefaults.standard.string(forKey: "number") else { return }
                print(phoneNumber)
                self?.getCertificationMessage(phoneNumber: phoneNumber)
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRealy.asSignal(),
            ableStartButton: ableStartButtonRelay.asSignal(),
            showSingUpVC: showSingUpVCRelay.asSignal(),
            showMainVC: showMainVCRelay.asSignal(),
            resendCode: resendCodeRelay.asSignal(),
            showToast: showToastRelay.asSignal()
        )
    }
}

extension CertificationViewModel {
    private func getCertificationMessage(phoneNumber: String) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
                if let id = verificationID {
                    UserDefaults.standard.set(id, forKey: "verificationID")
                    self?.resendCodeRelay.accept(())
                }
            }
    }
    private func verificationButtonClicked(code: String?) {
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID"), let verificationCode = code else {
            return
        }
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        logIn(credential: credential)
    }
    private func logIn(credential: PhoneAuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self?.showToastRelay.accept(SLPAssets.RawString.certifciationfailure.text)
            } else {
                self?.showSingUpVCRelay.accept(())
                UserDefaults.standard.removeObject(forKey: "number")
            }
        }
    }
}
