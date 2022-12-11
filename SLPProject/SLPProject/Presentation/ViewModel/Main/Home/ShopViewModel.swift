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
    
    var collectionSection = BehaviorRelay(value: [
        SeSACIconCollectionSectionModel(header: "", items: [
            SeSACIconCollectionModel(imageString: SeSACIconModel.first.iconImageString, titleText: SeSACIconModel.first.titleText, descriptionText: SeSACIconModel.first.descriptionText),
            SeSACIconCollectionModel(imageString: SeSACIconModel.second.iconImageString, titleText: SeSACIconModel.second.titleText, descriptionText: SeSACIconModel.second.descriptionText),
            SeSACIconCollectionModel(imageString: SeSACIconModel.third.iconImageString, titleText: SeSACIconModel.third.titleText, descriptionText: SeSACIconModel.third.descriptionText),
            SeSACIconCollectionModel(imageString: SeSACIconModel.fourth.iconImageString, titleText: SeSACIconModel.fourth.titleText, descriptionText: SeSACIconModel.fourth.descriptionText),
            SeSACIconCollectionModel(imageString: SeSACIconModel.fifth.iconImageString, titleText: SeSACIconModel.fifth.titleText, descriptionText: SeSACIconModel.fifth.descriptionText)
        ])
    ])
    
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
