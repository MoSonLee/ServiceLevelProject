//
//  HomeTabViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/18.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeTabViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let gpsButtonTapped: Signal<Void>
        let allButtonTapped: Signal<Void>
        let boyButtonTapped: Signal<Void>
        let girlButtonTapped: Signal<Void>
        let searchButtonTapped: Signal<Void>
    }
    
    struct Output {
        let showAlert: Signal<String>
        let changeButtonImage: Signal<String>
    }
    
    var userLocation = UserLocationModel(lat: 0.0, long: 0.0)
    var userSearch = UserSearchModel(lat: 0.0, long: 0.0, studylist: [])
    
    private let showAlertRelay = PublishRelay<String>()
    private let changeButtonImageRelay = PublishRelay<String>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        return Output(
            showAlert: showAlertRelay.asSignal(),
            changeButtonImage: changeButtonImageRelay.asSignal()
        )
    }
}

extension HomeTabViewModel {
    
    private func checkMyQueueState() {
        APIService().checkMyQueueState { result in
            switch result {
            case .success(let data):
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func requestSearchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userSearch.toDictionary) { result in
            switch result {
            case .success(let data):
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userLocation.toDictionary) { result in
            switch result {
            case .success(let data):
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func stopSearchSeSAC() {
        APIService().stopSearchSeSAC { result in
            switch result {
            case .success(let data):
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

