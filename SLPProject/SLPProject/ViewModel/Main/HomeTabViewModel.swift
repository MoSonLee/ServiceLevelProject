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
        let changeAllButton: Signal<Void>
        let changeBoyButton: Signal<Void>
        let changeGirlButton: Signal<Void>
    }
    
    var userLocation = UserLocationModel(lat: 0.0, long: 0.0)
    var userSearch = UserSearchModel(lat: 0.0, long: 0.0, studylist: [])
    
    private let showAlertRelay = PublishRelay<String>()
    private let changeButtonImageRelay = PublishRelay<String>()
    private let changeAllButtonRelay = PublishRelay<Void>()
    private let changeBoyButtonRelay = PublishRelay<Void>()
    private let changeGirlButtonRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.checkMyQueueState()
            })
            .disposed(by: disposeBag)
        
        input.gpsButtonTapped
            .emit(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
        
        input.allButtonTapped
            .emit(onNext: { [weak self] in
                self?.changeAllButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.boyButtonTapped
            .emit(onNext: { [weak self] in
                self?.changeBoyButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.girlButtonTapped
            .emit(onNext: { [weak self] in
                self?.changeGirlButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
            .emit(onNext: { [weak self] in
                self?.requestSearchSeSAC()
            })
            .disposed(by: disposeBag)
        
        return Output(
            showAlert: showAlertRelay.asSignal(),
            changeButtonImage: changeButtonImageRelay.asSignal(),
            changeAllButton: changeAllButtonRelay.asSignal(),
            changeBoyButton: changeBoyButtonRelay.asSignal(),
            changeGirlButton: changeGirlButtonRelay.asSignal()
        )
    }
}

extension HomeTabViewModel {
    
    private func checkMyQueueState() {
        APIService().checkMyQueueState { result in
            switch result {
            case .success(let response):
                print(response)
                print("AAAA")
                
            case .failure(let error):
                let error = QueueStateError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                switch error {
                case .notRequestYet:
                    print(QueueStateError.notRequestYet)
                    
                case .tokenError:
                    print(QueueStateError.notRequestYet)
                    
                case .unregisteredError:
                    print(QueueStateError.unregisteredError)
                    
                case .serverError:
                    print(QueueStateError.serverError)
                    
                case .clientError:
                    print(QueueStateError.clientError)
                    
                case .unknown:
                    print(QueueStateError.unknown)
                    
                }
            }
        }
    }
    
    private func requestSearchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userSearch.toDictionary) { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(UserSearchModel.self, from: response.data)
                print(data)
                print("AAAAAA")
                
            case .failure(let error):
                print(error)
                print("BBBBB")
            }
        }
    }
    
    private func searchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userLocation.toDictionary) { result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(UserLocationModel.self, from: response.data)
                print(data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func stopSearchSeSAC() {
        APIService().stopSearchSeSAC { result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
