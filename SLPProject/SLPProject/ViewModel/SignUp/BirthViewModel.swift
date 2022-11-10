//
//  BirthViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let textFieldChanged: Signal<(String, String, String)>
        let nextButtonClikced: Signal<(String, String, String)>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let ableNextButton: Signal<Bool>
        let showToast: Signal<String>
        let showMailVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    private let showMailVCRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.textFieldChanged
            .emit(onNext: { [weak self] textFieldText in
                if textFieldText.0.isEmpty || textFieldText.1.isEmpty || textFieldText.2.isEmpty {
                    self?.ableNextButtonRelay.accept(false)
                    print("success \(textFieldText)")
                } else {
                    self?.ableNextButtonRelay.accept(true)
                    print("failure \(textFieldText)")
                }
            })
            .disposed(by: disposeBag)
        
        input.nextButtonClikced
            .emit(onNext: { [weak self] textFieldText in
                self?.showToastRelay.accept(SLPAssets.RawString.ageLimit.text)
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            showMailVC: showMailVCRelay.asSignal()
        )
    }
}
