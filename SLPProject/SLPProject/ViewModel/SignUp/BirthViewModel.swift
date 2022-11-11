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
        let datePickerValueChanged: Signal<Date>
        let nextButtonClikced: Signal<Date>
    }
    
    struct Output {
        let becomeFirstResponder: Signal<Void>
        let popVC: Signal<Void>
        let ableNextButton: Signal<Bool>
        let setBirthData: Signal<(String,String,String)>
        let showToast: Signal<String>
        let showMailVC: Signal<Void>
    }
    
    private let becomeFirstResponderRelay = PublishRelay<Void>()
    private let popVCRelay = PublishRelay<Void>()
    private let ableNextButtonRelay = PublishRelay<Bool>()
    private let setBirthTextRelay = PublishRelay<(String, String, String)>()
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
            .emit(to: popVCRelay)
            .disposed(by: disposeBag)
        
        input.datePickerValueChanged
            .emit { [weak self] date in
                guard let selectedDateString = self?.dateformat(date: date) else { return }
                self?.ableNextButtonRelay.accept(true)
                self?.setBirthTextRelay.accept(selectedDateString)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonClikced
            .emit(onNext: { [weak self] selectedDate in
                guard let age = Calendar.current.dateComponents([.year], from: selectedDate, to: Date()).year else { return }
                age >= 17 ? self?.showMailVCRelay.accept(()) : self?.showToastRelay.accept(SLPAssets.RawString.ageLimit.text)
            })
            .disposed(by: disposeBag)
        
        return Output(
            becomeFirstResponder: becomeFirstResponderRelay.asSignal(),
            popVC: popVCRelay.asSignal(),
            ableNextButton: ableNextButtonRelay.asSignal(),
            setBirthData: setBirthTextRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            showMailVC: showMailVCRelay.asSignal()
        )
    }
}

extension BirthViewModel {
    private func dateformat(date: Date) -> (String, String, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        return (year, month, day)
    }
}
