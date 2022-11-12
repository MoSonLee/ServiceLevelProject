//
//  GenderViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class GenderViewModel {
    
    struct Input {
        let backButtonTapped: Signal<Void>
        let boyButtonTapped: Signal<Void>
        let girlButtonTapped: Signal<Void>
        let nextButtonTapped: Signal<Void>
    }
    
    struct Output {
        let highlightBoyButton: Signal<Void>
        let highlightGirlButton: Signal<Void>
        let ableNextButton: Signal<Void>
        let popVC: Signal<Void>
        let showToast: Signal<String>
        let showMainVC: Signal<Void>
    }
    
    private var genderValue = -1
    private let highlightBoyButtonRelay = PublishRelay<Void>()
    private let highlightGirlButtonRelay = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Void>()
    private let popVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let showMainVCRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private let provider: MoyaProvider<SLPTarget>
    init() { provider = MoyaProvider<SLPTarget>() }
    
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .do { [weak self] _ in self?.genderValue = -1 }
            .emit(to: popVCRelay)
            .disposed(by: disposeBag)
        
        input.boyButtonTapped
            .do { [weak self] _ in self?.genderValue = 1 }
            .emit(to: highlightBoyButtonRelay)
            .disposed(by: disposeBag)
        
        input.boyButtonTapped
            .do { [weak self] _ in self?.genderValue = 1 }
            .emit(to: ableNextButtonRelay)
            .disposed(by: disposeBag)
        
        input.girlButtonTapped
            .do { [weak self] _ in self?.genderValue = 0 }
            .emit(to: highlightGirlButtonRelay)
            .disposed(by: disposeBag)
        
        input.girlButtonTapped
            .do { [weak self] _ in self?.genderValue = 0 }
            .emit(to: ableNextButtonRelay)
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .emit(onNext: { [weak self] _ in
                if self?.genderValue != -1 {
                    self?.showMainVCRelay.accept(())
                    guard let genderValue = self?.genderValue else { return }
                    UserDefaults.gender = genderValue
                } else {
                    self?.showToastRelay.accept(SLPAssets.RawString.selectGender.text)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            highlightBoyButton: highlightBoyButtonRelay.asSignal(),
            highlightGirlButton: highlightGirlButtonRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            popVC: popVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            showMainVC: showMainVCRelay.asSignal()
        )
    }
}

//MARK: 서버 통신 로직 구현 예정
//extension GenderViewModel {
//    private func requestSignUpUser() {
//        let parameters = ["hash": ""]
//        provider.request(.login(parameters: parameters)) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                let data = try! JSONDecoder().decode(UserAccounts.self, from: response.data)
//                if data.userId.isEmpty{
//                    self.showMainVCRelay.accept(())
//                    print("already User")
//                }
//            case .failure(let error):
//                }
//            }
//        }
//    }
//}
