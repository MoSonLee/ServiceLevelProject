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
        let numberTextFiledCompleted: Signal<String>
        let sendMessageButtonTapped: Signal<Void>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let ableMessageButton: Signal<Bool>
        let showCertificationVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let ableMessageButtonRelay = PublishRelay<Bool>()
    private let showCertificationVCRelay = PublishRelay<Void>()

    private let dispsseBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: dispsseBag)
        
        input.numberTextFiledCompleted
            .emit(onNext: { [weak self] text in
                if text.count == 11 {
                    self?.ableMessageButtonRelay.accept((true))
                } else {
                    self?.ableMessageButtonRelay.accept((false))
                }
            })
            .disposed(by: dispsseBag)
        
        input.sendMessageButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.showCertificationVCRelay.accept(())
            })
            .disposed(by: dispsseBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            ableMessageButton: ableMessageButtonRelay.asSignal(),
            showCertificationVC: showCertificationVCRelay.asSignal())
    }
}
