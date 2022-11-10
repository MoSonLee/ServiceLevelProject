//
//  BirthViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let textFieldChanged: Signal<(String, String, String)>
        let nextButtonClikced: Signal<(String, String, String)>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let popVC: Signal<Void>
        let ableNextButton: Signal<Bool>
        let showToast: Signal<String>
        let showMailVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let popVCRealy = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    private let showMailVCRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.becomeFirstResponderRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .emit(onNext: { [weak self] _ in
                self?.popVCRealy.accept(())
            })
            .disposed(by: disposeBag)
        
        input.textFieldChanged
            .emit(onNext: { [weak self] textFieldText in
                if textFieldText.0.isEmpty || textFieldText.1.isEmpty || textFieldText.2.isEmpty {
                    self?.ableNextButtonRelay.accept(false)
                } else {
                    self?.ableNextButtonRelay.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.nextButtonClikced
            .emit(onNext: { [weak self] textFieldText in
                self?.checkValidateAge(text0: textFieldText.0, text1: textFieldText.1, text2: textFieldText.2)
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRealy.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            showMailVC: showMailVCRelay.asSignal()
        )
    }
}

extension BirthViewModel {
    private func currentDateYearToString() -> String {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func currentDateMonthAndDayToString() -> String {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func checkValidateAge(text0: String, text1: String, text2: String) {
        var monthString = ""
        var dayString = ""
        if text1 < "10" {
            monthString = "0\(text1)"
        } else {
            monthString = String(text1)
        }
        if text2 < "10" {
            dayString = "0\(text2)"
        } else {
            dayString = String(text2)
        }
        let monthDay = monthString + dayString
        
        if text0.isEmpty || text1.isEmpty || text2.isEmpty {
            showToastRelay.accept(SLPAssets.RawString.writeAllCases.text)
        } else if (Int(currentDateYearToString() ) ?? 0) - (Int(text0) ?? 0) >= 17 && (Int(currentDateMonthAndDayToString() ) ?? 0) - (Int(monthDay) ?? 0) >= 0 {
            showMailVCRelay.accept(())
        } else {
            showToastRelay.accept(SLPAssets.RawString.ageLimit.text)
        }
    }
}
