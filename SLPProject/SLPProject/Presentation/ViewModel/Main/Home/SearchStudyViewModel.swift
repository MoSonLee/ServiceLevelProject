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
        let viewDidLoad: Observable<Void>
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
    
    var sections = BehaviorRelay(value: [
        SearchCollecionSectionModel(header: "지금 주변에는", items: [
        ]),
        SearchCollecionSectionModel(header: "내가 하고 싶은", items: [
        ])
    ])
    
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var dbData: [SearchCollecionModel] = []
    
    private var userSearch = UserSearchModel(lat: 0.0, long: 0.0, studylist: [])
    private var studyList: [String] = []
    
    private let popVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let addCollectionModelRelay = PublishRelay<SearchCollecionModel>()
    private let checkCountRelay = PublishRelay<SearchCollecionSectionModel>()
    private let deleteStudyRelay = PublishRelay<IndexPath>()
    private let moveToNearUserVCRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.setRecommended()
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRelay.accept(())
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
                guard let self = self else { return }
                self.studyList.isEmpty ? self.studyList.append("anything") : nil
                self.userSearch = UserSearchModel(lat: self.location.latitude, long: self.location.longitude, studylist: self.studyList)
                self.requestSearchSeSAC()
            }
            .disposed(by: disposeBag)
        
        return Output(
            popVC: popVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            addCollectionModel: addCollectionModelRelay.asSignal(),
            checkCount: checkCountRelay.asSignal(),
            deleteStudy: deleteStudyRelay.asSignal(),
            moveToNearUserVC: moveToNearUserVCRelay.asSignal()
        )
    }
}

extension SearchStudyViewModel {
    
    private func setRecommended() {
        let array = sections.value
        sections.accept(acceptDB(array: array))
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
                setSectionValue(model: SearchCollecionModel(title: $0), section: sections)
                addCollectionModelRelay.accept(SearchCollecionModel(title: $0))
            }
        }
    }
    
    private func cellTapEvent(indexPath: IndexPath) {
        if indexPath.section == 1 {
            studyList.remove(at: indexPath.item)
            deleteSectionValue(indexPath: indexPath, section: sections)
            deleteStudyRelay.accept(indexPath)
        } else {
            if studyList.count < 8 {
                if studyList.contains(dbData[indexPath.item].title) {
                    showToastRelay.accept(SLPAssets.RawString.duplicateStudy.text)
                } else {
                    studyList.append(dbData[indexPath.item].title)
                    setSectionValue(model: SearchCollecionModel(title: dbData[indexPath.item].title), section: sections)
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
                UserDefaults.homeTabMode = .matching
                
            case .failure(let error):
                let error = UserSearchError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .reported3:
                    self?.showToastRelay.accept(SLPAssets.RawString.reported.text)
                case .cancelOnce:
                    self?.showToastRelay.accept(SLPAssets.RawString.penalty1.text)
                case .cancelTwo:
                    self?.showToastRelay.accept(SLPAssets.RawString.penalty2.text)
                case .cancelThree:
                    self?.showToastRelay.accept(SLPAssets.RawString.penalty3.text)
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
    
    func acceptDB(array: [SearchCollecionSectionModel]) -> [SearchCollecionSectionModel] {
        var array = array
        dbData.forEach { array[0].items.append($0) }
        print(array)
        return array
    }
    
    func setSectionValue(model: SearchCollecionModel, section: BehaviorRelay<[SearchCollecionSectionModel]>) {
        var array = section.value
        array[1].items.append(model)
        section.accept(array)
    }
    
    func deleteSectionValue(indexPath: IndexPath, section: BehaviorRelay<[SearchCollecionSectionModel]>) {
        var array = section.value
        array[1].items.remove(at: indexPath.item)
        section.accept(array)
    }
}
