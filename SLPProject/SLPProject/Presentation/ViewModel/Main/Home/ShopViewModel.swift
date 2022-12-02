//
//  ShopViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/03.
//

import Foundation

import RxCocoa
import RxSwift

final class ShopViewModel {
    
    struct Input {
        let sesacButtonTapped: Signal<Void>
        let backgroundButtonTapped: Signal<Void>
    }
    
    struct Output {
        let selectedTab: Driver<ShopTabModel>
        let showToast: Signal<String>
    }
    
    private let selectedTabRelay = BehaviorRelay<ShopTabModel>(value: .sesac)
    private let showToastRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.sesacButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.selectedTabRelay.accept(.sesac)
            })
            .disposed(by: disposeBag)
        
        input.backgroundButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.selectedTabRelay.accept(.background)
            })
            .disposed(by: disposeBag)
        return Output(
            selectedTab: selectedTabRelay.asDriver(),
            showToast: showToastRelay.asSignal()
        )
    }
}
