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
        let stopButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let selectedTab: Driver<SeSACTabModel>
        let checkDataCount: Signal<Bool>
        let getTableViewData: Signal<NearSeSACTableModel>
        let getrequested: Signal<NearSeSACTableModel>
    }
    
    var queueDB: [QueueDB] = []
    var recommendedQueueDB: [QueueDB] = []
    var userLocation = UserLocationModel(lat: 0, long: 0)
    var userId: [StudyRequestModel] = []
    
    private let popVCRelay = PublishRelay<Void>()
    private let selectedTabRelay = BehaviorRelay<SeSACTabModel>(value: .near)
    let checkDataCountRelay = PublishRelay<Bool>()
    let getQueueDBTableViewDataRelay = PublishRelay<NearSeSACTableModel>()
    let getrequestedRelay = PublishRelay<NearSeSACTableModel>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.searchSeSAC()
            })
            .disposed(by: disposeBag)
        
        input.stopButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.stopSearchSeSAC()
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
            selectedTab: selectedTabRelay.asDriver(),
            checkDataCount: checkDataCountRelay.asSignal(),
            getTableViewData: getQueueDBTableViewDataRelay.asSignal(),
            getrequested: getrequestedRelay.asSignal()
        )
    }
}

extension NearUserViewModel {
    
    private func searchSeSAC() {
        APIService().sesacSearch(dictionary: userLocation.toDictionary) { [weak self] result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(SeSACSearchResultModel.self, from: response.data)
                self?.hasData(data: data)
                
                data.fromQueueDB.forEach {
                    self?.queueDB.append($0)
                    self?.getQueueDBTableViewDataRelay.accept(NearSeSACTableModel(backGroundImage: $0.background, title: $0.nick, reputation: $0.reputation, studyList: $0.studylist, review: $0.reviews))
                    self?.userId.append(StudyRequestModel(otheruid: $0.uid))
                }
                
                data.fromQueueDBRequested.forEach {
                    self?.recommendedQueueDB.append($0)
                    self?.recommendedQueueDB.forEach {
                        self?.getrequestedRelay.accept(NearSeSACTableModel(backGroundImage: $0.background, title: $0.nick, reputation: $0.reputation, studyList: $0.studylist, review: $0.reviews))
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func studyRequest(index: Int) {
        APIService().studyRequest(dictionary: userId[index].toDictionary) { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func stopSearchSeSAC() {
        APIService().stopSearchSeSAC { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                UserDefaults.homeTabMode = .search
                self?.popVCRelay.accept(())
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func hasData(data: SeSACSearchResultModel) {
        data.fromQueueDB.count != 0 ? checkDataCountRelay.accept(true) :
        checkDataCountRelay.accept(false)
    }
}
