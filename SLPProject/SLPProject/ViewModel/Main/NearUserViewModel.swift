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
        let nearButtonTapped: Signal<Void>
        let receivedButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let selectedTab: Driver<SeSACTabModel>
    }
    
    private let popVCRelay = PublishRelay<Void>()
    private let selectedTabRelay = BehaviorRelay<SeSACTabModel>(value: .near)
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.nearButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.selectedTabRelay.accept(.near)
            })
            .disposed(by: disposeBag)
        
        input.receivedButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.selectedTabRelay.accept(.receive)
            })
            .disposed(by: disposeBag)
        
        return Output(
            popVC: popVCRelay.asSignal(),
            selectedTab: selectedTabRelay.asDriver()
            )
    }
}
