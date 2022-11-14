//
//  InitialViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/13.
//

import Foundation

import RxCocoa
import RxSwift

final class InitialViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let showToast: Signal<String>
        let showOnboardingVC: Signal<Void>
        let showMainVC: Signal<Void>
        let showLoginVC: Signal<Void>
        let showNicknameVC: Signal<Void>
    }
    
    private let userFCMtoken = UserFCMtoken(FCMtoken: UserDefaults.fcmToken)
    
    private let checkNetworkRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let showOnboardingVCRelay = PublishRelay<Void>()
    private let showMainVCRelay = PublishRelay<Void>()
    private let showLoginVCRelay = PublishRelay<Void>()
    private let showNicknameVCRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.checkNetwork()
            })
            .disposed(by: disposeBag)
        
        return Output(
            showToast: showToastRelay.asSignal(),
            showOnboardingVC: showOnboardingVCRelay.asSignal(),
            showMainVC: showMainVCRelay.asSignal(),
            showLoginVC: showLoginVCRelay.asSignal(),
            showNicknameVC: showNicknameVCRelay.asSignal()
        )
    }
}

extension InitialViewModel {
    private func checkNetwork() {
        InternetConnectionManager.isConnectedToNetwork() ? checkUserSigned() : showToastRelay.accept(SLPAssets.RawString.checkNetwork.text)
    }
    
    private func checkUserSigned() {
        APIService().responseGetUser { [weak self] result in
            switch result {
            case .success(_):
                self?.showMainVCRelay.accept(())
                
            case .failure(let error):
                let error = SLPLoginError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .tokenError:
                    self?.updateFMCtoken()
                    
                case .unRegisteredUser:
                    if UserDefaults.showOnboarding {
                        self?.showOnboardingVCRelay.accept(())
                    } else {
                        if UserDefaults.verified {
                            self?.showNicknameVCRelay.accept(())
                        } else {
                            self?.showLoginVCRelay.accept(())
                        }
                    }
                case .serverError:
                    print(SLPLoginError.serverError)
                    
                case .clientError:
                    print(SLPLoginError.clientError)
                    
                case .unknown:
                    print(SLPLoginError.unknown)
                    
                }
            }
        }
    }
    
    private func updateFMCtoken() {
        APIService().updateFMCtoken(dictionary: self.userFCMtoken.toDictionary) { result in
            switch result {
            case .success(_):
                print("token 갱신 완료")
                
            case .failure(let error):
                let error = SLPUpdateFcmTokenError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                print(error)
            }
        }
    }
}
