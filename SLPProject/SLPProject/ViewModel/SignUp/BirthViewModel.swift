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
            .map (checkText )
            .emit(to: ableNextButtonRelay)
            .disposed(by: disposeBag)
        
//        input.nextButtonClikced
//            .filter { $0.0.isEmpty || $0.1.isEmpty || $0.2.isEmpty }
//            .map {_ in SLPAssets.RawString.writeAllCases.text }
//            .emit(to: showToastRelay)
//            .disposed(by: disposeBag)

        input.nextButtonClikced
            .emit(onNext: { [weak self] textFieldText in
                if textFieldText.0.isEmpty || textFieldText.1.isEmpty || textFieldText.2.isEmpty {
                    self?.showToastRelay.accept(SLPAssets.RawString.writeAllCases.text)
                } else {
                    self?.checkValidateAge(text0: textFieldText.0, text1: textFieldText.1, text2: textFieldText.2)
                }
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
    private func checkText( texts: (String, String, String)) -> Bool {
        return !(texts.0.isEmpty || texts.1.isEmpty || texts.2.isEmpty)
    }
}

//MARK: 쓰레기 분리 수거
extension BirthViewModel {
    
    private func checkValidateAge(text0: String, text1: String, text2: String) {
        
        guard let currentYear = Int(currentYear(date: Date())) else { return }
        guard let currentMonth = Int(currentMonth(date: Date())) else { return }
        guard let currentDay = Int(currentDay(date: Date())) else { return }
        guard let yearText = Int(text0) else { return }
        guard let monthText = Int(text1) else { return}
        guard let dayText = Int(text2) else { return }
        
        if currentYear - yearText > 17 {
            showMailVCRelay.accept(())
        } else if currentYear - yearText < 17 {
            showToastRelay.accept(SLPAssets.RawString.ageLimit.text)
        } else {
            if currentMonth > monthText {
                showMailVCRelay.accept(())
            } else if currentMonth < monthText {
                showToastRelay.accept(SLPAssets.RawString.ageLimit.text)
            } else  {
                if currentDay >= dayText {
                    showMailVCRelay.accept(())
                } else {
                    showToastRelay.accept(SLPAssets.RawString.ageLimit.text)
                }
            }
        }
    }
    
    private func currentYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func currentMonth(date: Date) -> String {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func currentDay(date: Date) -> String {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
