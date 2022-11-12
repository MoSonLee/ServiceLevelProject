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
        let moveToNicknameVC: Signal<Void>
    }
    
    private var genderValue = -1
    private let highlightBoyButtonRelay = PublishRelay<Void>()
    private let highlightGirlButtonRelay = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Void>()
    private let popVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let showMainVCRelay = PublishRelay<Void>()
    private let moveToNicknameVCRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var User = UserAccounts(
        phoneNumber: "",
        FCMtoken: "",
        nick: "",
        birth: "",
        email: "",
        gender: -1
    )
    
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
                self?.requestSignUpUser()
            })
            .disposed(by: disposeBag)
        
        return Output(
            highlightBoyButton: highlightBoyButtonRelay.asSignal(),
            highlightGirlButton: highlightGirlButtonRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            popVC: popVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            showMainVC: showMainVCRelay.asSignal(),
            moveToNicknameVC: moveToNicknameVCRelay.asSignal()
        )
    }
}

extension GenderViewModel {
    private func requestSignUpUser() {
        self.User = UserAccounts(
            phoneNumber: UserDefaults.userNumber,
            FCMtoken: AppDelegate.fcmToken,
            nick: UserDefaults.nick,
            birth: UserDefaults.birth,
            email: UserDefaults.userEmail,
            gender: genderValue
        )
        provider.request(.signUp(parameters: self.User.toDictionary)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.showMainVCRelay.accept(())
                
            case .failure(let error):
                self.showToastRelay.accept(SLPAssets.RawString.selectGender.text)
                print(error)
                let error = SLPSignUpError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .registeredUser:
                    print(SLPSignUpError.registeredUser)
                case .invalidateNickname:
                    print(SLPSignUpError.invalidateNickname)
                    self.moveToNicknameVCRelay.accept(())
                case .tokenError:
                    print(SLPSignUpError.tokenError)
                case .unRegisteredUser:
                    print(SLPSignUpError.unRegisteredUser)
                case .serverError:
                    print(SLPSignUpError.serverError)
                case .clientError:
                    print(SLPSignUpError.clientError)
                case .unknown:
                    print(SLPSignUpError.unknown)
                }
            }
        }
    }
}

