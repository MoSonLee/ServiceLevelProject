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
    private let popVCRelay = PublishRelay<Void>()
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
            .emit(to: popVCRelay)
            .disposed(by: disposeBag)
        
        input.nickNameTextFieldCompleted
            .map { $0.count > 0 && $0.count <= 10 }
            .emit(to: ableNextButtonRelay)
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .do { nick in UserDefaults.nick = nick }
            .filter { $0.count > 0 && $0.count <= 10 }
            .map { _ in () }
            .emit(to: showBirthVCRelay)
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .filter { !($0.count > 0 && $0.count <= 10) }
            .map { _ in SLPAssets.RawString.writeNickNameLetters.text }
            .emit(to: showToastRelay)
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRelay.asSignal(),
            checkNickNameTextField: checkNickNameTextFieldRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            showBirthVC: showBirthVCRelay.asSignal()
        )
    }
}
