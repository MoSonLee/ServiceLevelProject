//
//  NearUserViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/25.
//

import Foundation

import RxCocoa
import RxSwift

final class NearUserViewModel {
    
    struct Input {
        let backButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
    }
    
    private let popVCRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(popVC: popVCRelay.asSignal())
    }
}
