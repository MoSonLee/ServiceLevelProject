//
//  SearchStudyViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/22.
//

import Foundation
import CoreLocation

import RxCocoa
import RxSwift

final class SearchStudyViewModel {
    
    struct Input {
        let backButtonTapped: Signal<Void>
        let searchBarButtonTapped: Signal<String>
        let cellTapped: Signal<IndexPath>
        let searchButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let showToast: Signal<String>
        let addCollectionModel: Signal<SearchCollecionModel>
        let checkCount: Signal<SearchCollecionSectionModel>
        let deleteStudy: Signal<IndexPath>
        let moveToNearUserVC: Signal<Void>
    }
    
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var dbData: [SearchCollecionModel] = []
    private var userSearch = UserSearchModel(lat: 0.0, long: 0.0, studylist: "anything")
    
    private var studyList: [String] = []
    private let popVCRealy = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let addCollectionModelRelay = PublishRelay<SearchCollecionModel>()
    private let checkCountRelay = PublishRelay<SearchCollecionSectionModel>()
    private let deleteStudyRelay = PublishRelay<IndexPath>()
    private let moveToNearUserVCRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRealy.accept(())
            })
            .disposed(by: disposeBag)
        
        input.searchBarButtonTapped
            .emit(onNext: { [weak self] text in
                self?.checkTextCount(text: text)
            })
            .disposed(by: disposeBag)
        
        input.cellTapped
            .emit { [weak self] indexPath in
                self?.cellTapEvent(indexPath: indexPath)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
            .emit { [weak self] _ in
                guard let location = self?.location else { return }
                self?.userSearch = UserSearchModel(lat: location.latitude, long: location.longitude, studylist: "\(String(describing: self?.studyList))")
                self?.requestSearchSeSAC()
            }
            .disposed(by: disposeBag)
        
        return Output(
            popVC: popVCRealy.asSignal(),
            showToast: showToastRelay.asSignal(),
            addCollectionModel: addCollectionModelRelay.asSignal(),
            checkCount: checkCountRelay.asSignal(),
            deleteStudy: deleteStudyRelay.asSignal(),
            moveToNearUserVC: moveToNearUserVCRelay.asSignal()
        )
    }
}

extension SearchStudyViewModel {
    func checkDbCount(array: [SearchCollecionSectionModel]) -> [SearchCollecionSectionModel] {
        var array = array
        dbData.forEach { array[0].items.append($0) }
        return array
    }
    private func checkTextCount(text: String) {
        let study = text.components(separatedBy: " ")
        study.forEach {
            if studyList.contains($0) {
                showToastRelay.accept(SLPAssets.RawString.duplicateStudy.text)
            } else if !(1...8).contains($0.count) {
                showToastRelay.accept(SLPAssets.RawString.validateSearchText.text)
            } else if studyList.count == 8 {
                showToastRelay.accept(SLPAssets.RawString.studyCountLimit.text)
            } else {
                studyList.append($0)
                addCollectionModelRelay.accept(SearchCollecionModel(title: $0))
            }
        }
    }
    
    private func cellTapEvent(indexPath: IndexPath) {
        if indexPath.section == 1 {
            studyList.remove(at: indexPath.item)
            deleteStudyRelay.accept(indexPath)
        } else {
            if studyList.count < 8 {
                if studyList.contains(dbData[indexPath.item].title) {
                    showToastRelay.accept(SLPAssets.RawString.duplicateStudy.text)
                } else {
                    studyList.append(dbData[indexPath.item].title)
                    addCollectionModelRelay.accept(SearchCollecionModel(title: studyList.last ?? ""))
                }
            } else {
                showToastRelay.accept(SLPAssets.RawString.studyCountLimit.text)
            }
        }
    }
    
    private func requestSearchSeSAC() {
        APIService().requestSearchSeSAC(dictionary: userSearch.toDictionary) { [weak self] result in
            switch result {
            case .success(_):
                self?.moveToNearUserVCRelay.accept(())
                
            case .failure(let error):
                let error = UserSearchErrorModel(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .Declaration3:
                    self?.showToastRelay.accept("신고가 누적되어 이용하실 수 없습니다")
                case .cancelOnce:
                    self?.showToastRelay.accept("스터디 취소 패널티로, 1분동안 이용하실 수 없습니다")
                case .cancelTwo:
                    self?.showToastRelay.accept("스터디 취소 패널티로, 2분동안 이용하실 수 없습니다")
                case .cancelThree:
                    self?.showToastRelay.accept("스터디 취소 패널티로, 3분동안 이용하실 수 없습니다")
                case .tokenError:
                    print(UserSearchErrorModel.tokenError)
                case .unregistered:
                    print(UserSearchErrorModel.unregistered)
                case .serverError:
                    print(UserSearchErrorModel.serverError)
                case .clientError:
                    print(UserSearchErrorModel.clientError)
                case .unknown:
                    print(UserSearchErrorModel.unknown)
                }
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
