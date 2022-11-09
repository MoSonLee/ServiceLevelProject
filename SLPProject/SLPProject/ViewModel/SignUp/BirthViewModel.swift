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
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal()
        )
    }
}
