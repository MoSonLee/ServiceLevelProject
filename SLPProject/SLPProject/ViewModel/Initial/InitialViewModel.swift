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
        if InternetConnectionManager.isConnectedToNetwork() { 
            if UserDefaults.showOnboarding {
                showOnboardingVCRelay.accept(())
            } else {
                if UserDefaults.verified {
                    showNicknameVCRelay.accept(())
                } else {
                    showLoginVCRelay.accept(())
                }
            }
        } else {
            showToastRelay.accept(SLPAssets.RawString.checkNetwork.text)
        }
    }
}
