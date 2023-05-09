//
//  OnBoardingViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import Foundation

import RxCocoa
import RxSwift

final class OnBoardingViewModel {
    
    struct Input {
        let startButtonTapped: Signal<Void>
    }
    
    struct Output {
        let showLoginVC: Signal<Void>
    }
    
    private let showLoginVCRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.startButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.showLoginVCRelay.accept(())
                UserDefaults.showOnboarding = false
            })
            .disposed(by: disposeBag)
        
        return Output(
            showLoginVC: showLoginVCRelay.asSignal()
        )
    }
}
