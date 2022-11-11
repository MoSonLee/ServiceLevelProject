//
//  CertificationViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class CertificationViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let certificationTextFieldCompleted: Signal<String>
        let startButtonTapped: Signal<String>
        let resendButtonTapped: Signal<Void>
        let multipleTimeResendButtonTapped: Signal<Void>
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
        
        input.multipleTimeResendButtonTapped
            .skip(5)
            .map{ _ in SLPAssets.RawString.tooMuchRequest.text}
            .emit(to: showToastRelay)
            .disposed(by: disposeBag)
        
        input.resendButtonTapped
            .throttle(.seconds(2), latest: false)
            .emit(onNext: { [weak self] _ in
                let phoneNumber =  UserDefaults.userNumber
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
        FirebaseAuthorization().getCertificationMessage(phoneNumber: phoneNumber) { [weak self] id, error in
            if id != nil {
                guard let id = id else { return }
                self?.resendCodeRelay.accept(())
                UserDefaults.userVerificationID = id
            }
        }
    }
    
    private func verificationButtonClicked(code: String?) {
        FirebaseAuthorization().verificationButtonClicked(code: code) { [weak self] result, error in
            if result != nil {
                self?.showSingUpVCRelay.accept(())
                self?.getToken()
            } else {
                self?.showToastRelay.accept(SLPAssets.RawString.certifciationfailure.text)
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
    
    private func getToken() {
        FirebaseAuthorization().getToken { token, error in
            if token != nil {
                guard let token = token else { return }
                UserDefaults.userToken = token
                print(token)
            } else {
                print(error ?? "Error")
            }
        }
    }
}
