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
        let moveToChatVC: Signal<Void>
        let showToast: Signal<String>
        let changeRootVC: Signal<Void>
    }
    
    var requestSection = BehaviorRelay(value: [
        NearSeSACTableSectionModel(header: "", items: [
        ])
    ])
    
    var acceptSection = BehaviorRelay(value: [
        NearSeSACTableSectionModel(header: "", items: [
        ])
    ])
    
    var userLocation = UserLocationModel(lat: 0, long: 0)
    
    private var queueDB: [QueueDB] = []
    private var recommendedQueueDB: [QueueDB] = []
    private var userId: [StudyRequestModel] = []
    private var acceptUserId: [StudyRequestModel] = []
    
    private let popVCRelay = PublishRelay<Void>()
    private let selectedTabRelay = BehaviorRelay<SeSACTabModel>(value: .near)
    private let checkDataCountRelay = PublishRelay<Bool>()
    private let getQueueDBTableViewDataRelay = PublishRelay<NearSeSACTableModel>()
    private let getrequestedRelay = PublishRelay<NearSeSACTableModel>()
    private let moveToChatVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let changeRootVCRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.searchSeSAC()
                self?.checkMyQueueState()
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
            getrequested: getrequestedRelay.asSignal(),
            moveToChatVC: moveToChatVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            changeRootVC: changeRootVCRelay.asSignal()
        )
    }
}

extension NearUserViewModel {
    
    private func searchSeSAC() {
        APIService().sesacSearch(dictionary: userLocation.toDictionary) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = try? JSONDecoder().decode(SeSACSearchResultModel.self, from: response.data) else { return }
                self?.getData(data: data)
                self?.hasData(data: data)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getData(data: SeSACSearchResultModel) {
        data.fromQueueDB.forEach {
            queueDB.append($0)
            acceptSectionValue(model: NearSeSACTableModel(backGroundImage: $0.background, title: $0.nick, reputation: $0.reputation, studyList: $0.studylist, review: $0.reviews), section: requestSection)
            getQueueDBTableViewDataRelay.accept(NearSeSACTableModel(backGroundImage: $0.background, title: $0.nick, reputation: $0.reputation, studyList: $0.studylist, review: $0.reviews))
            userId.append(StudyRequestModel(otheruid: $0.uid))
        }
        data.fromQueueDBRequested.forEach {
            recommendedQueueDB.append($0)
            acceptSectionValue(model: NearSeSACTableModel(backGroundImage: $0.background, title: $0.nick, reputation: $0.reputation, studyList: $0.studylist, review: $0.reviews), section: acceptSection)
            getrequestedRelay.accept(NearSeSACTableModel(backGroundImage: $0.background, title: $0.nick, reputation: $0.reputation, studyList: $0.studylist, review: $0.reviews))
            acceptUserId.append(StudyRequestModel(otheruid: $0.uid))
        }
    }
    
    func studyRequest(index: Int) {
        APIService().studyRequest(dictionary: userId[index].toDictionary) { [weak self] result in
            switch result {
            case .success(_):
                self?.showToastRelay.accept("스터디 요청을 보냈습니다.")
                
            case .failure(let error):
                let error = StudyRequestError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .alreadyRequested:
                    self?.acceptStudy(index: index)
                case .alreayCanceled:
                    self?.showToastRelay.accept("상대방이 스터디 찾기를 그만두었습니다")
                case .tokenError:
                    print(UserSearchError.tokenError)
                case .unregistered:
                    print(UserSearchError.unregistered)
                case .serverError:
                    print(UserSearchError.serverError)
                case .clientError:
                    print(UserSearchError.clientError)
                case .unknown:
                    print(UserSearchError.unknown)
                }
            }
        }
    }
    
    func acceptStudy(index: Int) {
        APIService().studyAccept(dictionary: acceptUserId[index].toDictionary) { [weak self] result in
            switch result {
            case .success(_):
                UserDefaults.homeTabMode = .message
                self?.moveToChatVCRelay.accept(())
                self?.changeRootVCRelay.accept(())
                
            case .failure(let error):
                let error = StudyAcceptError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .userAlreadyMatched:
                    self?.showToastRelay.accept("상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
                case .userCanceledStudy:
                    self?.showToastRelay.accept("상대방이 스터디 찾기를 그만두었습니다")
                case .alreadyMatched:
                    self?.checkMyQueueState()
                case .tokenError:
                    print(UserSearchError.tokenError)
                case .unregistered:
                    print(UserSearchError.unregistered)
                case .serverError:
                    print(UserSearchError.serverError)
                case .clientError:
                    print(UserSearchError.clientError)
                case .unknown:
                    print(UserSearchError.unknown)
                }
            }
        }
    }
    
    private func checkMyQueueState() {
        APIService().checkMyQueueState { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = try? JSONDecoder().decode(MyQueueStateModel.self, from: response.data) else { return }
                if data.matched == 1 {
                    self?.showToastRelay.accept("\(data.matchedNick)님과 매칭되셨습니다.")
                    UserDefaults.homeTabMode = .message
                    self?.moveToChatVCRelay.accept(())
                } else {
                    UserDefaults.homeTabMode = .matching
                }
                
            case .failure(let error):
                let error = QueueStateError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                switch error {
                case .notRequestYet:
                    print(QueueStateError.notRequestYet)
                    
                case .tokenError:
                    print(QueueStateError.tokenError)
                    
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
    
    private func stopSearchSeSAC() {
        APIService().stopSearchSeSAC { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                UserDefaults.homeTabMode = .search
                self?.popVCRelay.accept(())
                
            case .failure(let error):
                let error = StopSearchError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .alearyStoppedError:
                    self?.showToastRelay.accept("누군가와 스터디를 함께하기로 약속하셨어요!")
                    self?.moveToChatVCRelay.accept(())
                case .tokenError:
                    print(UserSearchError.tokenError)
                case .unregistered:
                    print(UserSearchError.unregistered)
                case .serverError:
                    print(UserSearchError.serverError)
                case .clientError:
                    print(UserSearchError.clientError)
                case .unknown:
                    print(UserSearchError.unknown)
                }
            }
        }
    }
    
    private func hasData(data: SeSACSearchResultModel) {
        data.fromQueueDB.count != 0 ? checkDataCountRelay.accept(true) : checkDataCountRelay.accept(false)
    }
    
    func acceptSectionValue(model: NearSeSACTableModel, section: BehaviorRelay<[NearSeSACTableSectionModel]>) {
        var array = section.value
        array[0].items.append(model)
        section.accept(array)
    }
}
