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
        let firstCellTapped: ControlEvent<IndexPath>
    }
    
    struct Output {
        let showMySecondInfoVC: Signal<IndexPath>
    }
    
    private let showMySecondInfoVCRelay = PublishRelay<IndexPath>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.firstCellTapped
            .subscribe { [weak self] indexPath in
                indexPath == [0,0] ? self?.showMySecondInfoVCRelay.accept([0,0]) : nil
            }
            .disposed(by: disposeBag)
        return Output(showMySecondInfoVC: showMySecondInfoVCRelay.asSignal())
    }
}
