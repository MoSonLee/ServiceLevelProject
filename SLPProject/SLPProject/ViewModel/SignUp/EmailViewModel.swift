//
//  EmailViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift

final class EmailViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let emailTextFieldCompleted: Signal<String>
        let nextButtonTapped: Signal<String>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let popVC: Signal<Void>
        let checkEmailTextField: Signal<String>
        let showToast: Signal<String>
        let ableNextButton: Signal<Bool>
        let showGenerVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let popVCRealy = PublishRelay<Void>()
    private let checkEmailTextFieldRelay = PublishRelay<String>()
    private let showGenerVCRelay = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRealy.accept(())
            })
            .disposed(by: disposeBag)
        
        input.emailTextFieldCompleted
            .emit(onNext: { [weak self] text in
                if text.count > 5 && text.contains("@") && text.contains(".") {
                    self?.ableNextButtonRelay.accept(true)
                } else {
                    self?.ableNextButtonRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .emit(onNext: { [weak self] text in
                if text.count > 5 && text.contains("@") && text.contains(".") {
                    self?.showGenerVCRelay.accept(())
                } else {
                    self?.showToastRelay.accept(SLPAssets.RawString.wrongEmailType.text)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRealy.asSignal(),
            checkEmailTextField: checkEmailTextFieldRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            showGenerVC: showGenerVCRelay.asSignal()
        )
    }
}
