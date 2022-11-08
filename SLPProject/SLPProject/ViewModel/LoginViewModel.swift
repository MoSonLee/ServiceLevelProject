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
        let checkMultipleTapped: Signal<String>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let changeToFormatNumberRelay = PublishRelay<Bool>()
    private let ableMessageButtonRelay = PublishRelay<Bool>()
    private let showCertificationVCRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    private let checkMultipleTappedRealy = PublishRelay<String>()
    private let dispsseBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: dispsseBag)
        
        input.numberTextFieldChanged
            .emit(onNext: { [weak self] text in
                let filterText = text.filter { "0123456789".contains($0) }
                if filterText.count == 11 {
                    self?.changeToFormatNumberRelay.accept((true))
                } else if filterText.count == 10 {
                    self?.changeToFormatNumberRelay.accept((false))
                }
            })
            .disposed(by: dispsseBag)
        
        input.numberTextFiledCompleted
            .emit(onNext: { [weak self] text in
                let filterText = text.filter { "0123456789".contains($0) }
                filterText.count >= 10 ? self?.ableMessageButtonRelay.accept((true)) : self?.ableMessageButtonRelay.accept((false))
            })
            .disposed(by: dispsseBag)
        
        input.sendMessageButtonTapped
            .emit(onNext: { [weak self] text in
                let filterText = text.filter { "0123456789".contains($0) }
                let startNumber = "01"
                if filterText.count < 10 || !filterText.starts(with: startNumber) {
                    self?.showToastRelay.accept(SLPAssets.RawString.notFormattedNumber.text)
                    self?.showCertificationVCRelay.accept((false))
                } else if filterText.count >= 10 && filterText.starts(with: startNumber) {
                    self?.showCertificationVCRelay.accept(true)
                } else {
                    self?.showToastRelay.accept(SLPAssets.RawString.etcError.text)
                    self?.showCertificationVCRelay.accept(false)
                }
            })
            .disposed(by: dispsseBag)
        
        input.multipleTimeMessageButtonTapped
            .throttle(.seconds(2))
            .delay(.seconds(1))
            .emit(onNext: { [weak self] text in
                self?.showToastRelay.accept(SLPAssets.RawString.tooMuchRequest.text)
            })
            .disposed(by: dispsseBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            changeToFormatNumber: changeToFormatNumberRelay.asSignal(),
            ableMessageButton: ableMessageButtonRelay.asSignal(),
            showCertificationVC: showCertificationVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            checkMultipleTapped: checkMultipleTappedRealy.asSignal()
        )
    }
}
