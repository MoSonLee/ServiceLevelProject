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
        let startButtonTapped: Signal<Void>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let popVC: Signal<Void>
        let ableStartButton: Signal<Bool>
        let showSingUpVC: Signal<Void>
        let showMainVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let popVCRealy = PublishRelay<Void>()
    private let ableStartButtonRelay = PublishRelay<Bool>()
    private let showSingUpVCRelay = PublishRelay<Void>()
    private let showMainVCRelay = PublishRelay<Void>()
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
        
        input.certificationTextFieldCompleted
            .emit(onNext: { [weak self] text in
                if text.count == 5 {
                    self?.ableStartButtonRelay.accept(true)
                } else {
                    self?.ableStartButtonRelay.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.startButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.showSingUpVCRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRealy.asSignal(),
            ableStartButton: ableStartButtonRelay.asSignal(),
            showSingUpVC: showSingUpVCRelay.asSignal(),
            showMainVC: showMainVCRelay.asSignal()
        )
    }
}
