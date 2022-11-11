//
//  GenderViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

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
    
    private var genderValue: Int?
    private let highlightBoyButtonRelay = PublishRelay<Void>()
    private let highlightGirlButtonRelay = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Void>()
    private let popVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let showMainVCRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRelay.accept(())
                UserDefaults.gender = -1
            })
            .disposed(by: disposeBag)
        
        input.boyButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.highlightBoyButtonRelay.accept(())
                UserDefaults.gender = 1
                self?.genderValue = 1
                self?.ableNextButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.girlButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.highlightGirlButtonRelay.accept(())
                self?.genderValue = 0
                UserDefaults.gender = 0
                self?.ableNextButtonRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.nextButtonTapped
            .emit(onNext: { [weak self] _ in
                if self?.genderValue != nil {
                    self?.showMainVCRelay.accept(())
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
extension GenderViewModel {
    
}
