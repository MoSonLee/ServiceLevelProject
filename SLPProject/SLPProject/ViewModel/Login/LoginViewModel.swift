//
//  LoginViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel{
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let numberTextFieldChanged: Signal<String>
        let numberTextFiledCompleted: Signal<String>
        let sendMessageButtonTapped: Signal<String>
        let multipleTimeMessageButtonTapped: Signal<Void>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let changeToFormatNumber: Signal<Bool>
        let ableMessageButton: Signal<Bool>
        let showCertificationVC: Signal<Bool>
        let showToast: Signal<String>
        
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let changeToFormatNumberRelay = PublishRelay<Bool>()
    private let ableMessageButtonRelay = PublishRelay<Bool>()
    private let showCertificationVCRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.numberTextFieldChanged
            .emit(onNext: { [weak self] text in
                let filterText = text.filter { "0123456789".contains($0) }
                if filterText.count > 0 && filterText.count != 10 {
                    self?.changeToFormatNumberRelay.accept((true))
                } else if filterText.count == 10 {
                    self?.changeToFormatNumberRelay.accept((false))
                }
            })
            .disposed(by: disposeBag)
        
        input.numberTextFiledCompleted
            .emit(onNext: { [weak self] text in
                let filterText = text.filter { "0123456789".contains($0) }
                filterText.count >= 10 ? self?.ableMessageButtonRelay.accept((true)) : self?.ableMessageButtonRelay.accept((false))
            })
            .disposed(by: disposeBag)
        
        input.sendMessageButtonTapped
            .throttle(.seconds(2), latest: false)
            .emit(onNext: { [weak self] text in
                let filterText = String(text.filter { "0123456789".contains($0) }.dropFirst(0))
                let startNumber = "01"
                let filterTextWithFormat = filterText.applyPatternOnNumbers(pattern: "+82##########", replacmentCharacter: "#")
                
                if filterText.count < 9 || !filterText.starts(with: startNumber) {
                    self?.showToastRelay.accept(SLPAssets.RawString.notFormattedNumber.text)
                    self?.showCertificationVCRelay.accept((false))
                } else if filterText.count >= 9 && filterText.starts(with: startNumber) {
                    self?.getCertificationMessage(phoneNumber: filterTextWithFormat)
                } else {
                    self?.showToastRelay.accept(SLPAssets.RawString.etcError.text)
                    self?.showCertificationVCRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.multipleTimeMessageButtonTapped
            .skip(5)
            .map{ _ in SLPAssets.RawString.tooMuchRequest.text}
            .emit(to: showToastRelay)
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            changeToFormatNumber: changeToFormatNumberRelay.asSignal(),
            ableMessageButton: ableMessageButtonRelay.asSignal(),
            showCertificationVC: showCertificationVCRelay.asSignal(),
            showToast: showToastRelay.asSignal()
        )
    }
}

extension LoginViewModel {
    private func getCertificationMessage(phoneNumber: String) {
        FirebaseAuthorization().getCertificationMessage(phoneNumber: phoneNumber) { [weak self] id, error in
            if let error = error {
                self?.showCertificationVCRelay.accept(false)
                print(error)
            } else {
                guard let id = id else { return }
                self?.showCertificationVCRelay.accept(true)
                UserDefaults.userVerificationID = id
                UserDefaults.userNumber = phoneNumber
                print(id)
            }
        }
    }
}
