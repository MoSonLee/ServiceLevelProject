//
//  NickNameViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift

final class NickNameViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let nickNameTextFieldCompleted: Signal<String>
        let nextButtonTapped: Signal<String>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let popVC: Signal<Void>
        let checkNickNameTextField: Signal<String>
        let showToast: Signal<String>
        let ableNextButton: Signal<Bool>
        let showBirthVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let popVCRealy = PublishRelay<Void>()
    private let checkNickNameTextFieldRelay = PublishRelay<String>()
    private let showBirthVCRelay = PublishRelay<Void>()
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
        
        input.nickNameTextFieldCompleted
            .emit(onNext: { [weak self] text in
                if text.count > 0 && text.count <= 10 {
                    self?.ableNextButtonRelay.accept(true)
                } else {
                    self?.ableNextButtonRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .emit(onNext: { [weak self] text in
                if text.count > 0 && text.count <= 10 {
                    self?.showBirthVCRelay.accept(())
                } else {
                    self?.showToastRelay.accept(SLPAssets.RawString.writeNickNameLetters.text)
                }
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRealy.asSignal(),
            checkNickNameTextField: checkNickNameTextFieldRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            showBirthVC: showBirthVCRelay.asSignal()
        )
    }
}
