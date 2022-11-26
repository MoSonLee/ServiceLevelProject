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
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let nearButtonTapped: Signal<Void>
        let receivedButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let selectedTab: Driver<SeSACTabModel>
    }
    
    var userLocation = UserLocationModel(lat: 0, long: 0)
    
    private let popVCRelay = PublishRelay<Void>()
    private let selectedTabRelay = BehaviorRelay<SeSACTabModel>(value: .near)
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.searchSeSAC()
            })
            .disposed(by: disposeBag)
        
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

extension NearUserViewModel {
    private func searchSeSAC() {
        APIService().sesacSearch(dictionary: userLocation.toDictionary) { [weak self] result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(SeSACSearchResultModel.self, from: response.data)
                print(data.fromQueueDB)
            case .failure(let error):
                print(error)
            }
        }
    }
}
