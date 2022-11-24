//
//  SearchStudyViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/22.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchStudyViewModel {
    
    struct Input {
        let backButtonTapped: Signal<Void>
        let searchButtonTapped: Signal<String>
        let cellTapped: Signal<IndexPath>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let showToast: Signal<String>
        let addCollectionModel: Signal<SearchCollecionModel>
        let checkCount: Signal<SearchCollecionSectionModel>
        let deleteStudy: Signal<IndexPath>
    }
    
    private var count = 0
    private var study: [String] = []
    private let popVCRealy = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let addCollectionModelRelay = PublishRelay<SearchCollecionModel>()
    private let checkCountRelay = PublishRelay<SearchCollecionSectionModel>()
    private let deleteStudyRelay = PublishRelay<IndexPath>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRealy.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
            .emit(onNext: { [weak self] text in
                self?.checkTextCount(text: text)
            })
            .disposed(by: disposeBag)
        
        input.cellTapped
            .emit { [weak self] indexPath in
                self?.count -= 1
                indexPath.section == 1 ? self?.deleteStudyRelay.accept(indexPath) : nil
            }
            .disposed(by: disposeBag)
        
        return Output(
            popVC: popVCRealy.asSignal(),
            showToast: showToastRelay.asSignal(),
            addCollectionModel: addCollectionModelRelay.asSignal(),
            checkCount: checkCountRelay.asSignal(),
            deleteStudy: deleteStudyRelay.asSignal()
        )
    }
}

extension SearchStudyViewModel {
    private func checkTextCount(text: String) {
        study = text.components(separatedBy: " ")
        study.forEach {
            if $0.count < 1 || $0.count > 8 {
                showToastRelay.accept(SLPAssets.RawString.validateSearchText.text)
            } else {
                count < 8 ? addCollectionModelRelay.accept(SearchCollecionModel(title: "\($0) X")) : showToastRelay.accept(SLPAssets.RawString.studyCountLimit.text)
                count += 1
            }
        }
    }
}
