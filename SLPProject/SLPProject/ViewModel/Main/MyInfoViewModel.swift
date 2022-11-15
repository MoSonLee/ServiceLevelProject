//
//  MyInfoViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import Foundation

import RxCocoa
import RxSwift

final class MyInfoViewModel {
    
    struct Input {
        let cellTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let showMySecondInfoVC: Signal<IndexPath>
    }
    
    private let showMySecondInfoVCRelay = PublishRelay<IndexPath>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.cellTapped
            .subscribe { [weak self] indexPath in
                self?.showMySecondInfoVCRelay.accept(indexPath)
            }
            .disposed(by: disposeBag)
        return Output(showMySecondInfoVC: showMySecondInfoVCRelay.asSignal())
    }
}
