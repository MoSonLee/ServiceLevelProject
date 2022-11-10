//
//  BirthViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class BirthViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let textLabel = UILabel()
    private let stackView = UIStackView()
    private let blockingButton = UIButton()
    private let yearTextField = CustomTextField()
    private let monthTextField = CustomTextField()
    private let dayTextField = CustomTextField()
    private let yearLabel = UILabel()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let firstLineView = UIView()
    private let secondLineView = UIView()
    private let thirdLineView = UIView()
    private let nextButton = UIButton()
    private let pickerView = UIPickerView()
    
    private var allYear: [Int] = []
    private let allMonth: [Int] = Array(1...12)
    private let allDay: [Int] = Array(1...31)
    
    private let viewModel = BirthViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var input = BirthViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        textFieldChanged: pickerView.rx.itemSelected
            .withLatestFrom(
                Observable.combineLatest(
                    yearTextField.rx.text.orEmpty,
                    monthTextField.rx.text.orEmpty,
                    dayTextField.rx.text.orEmpty
                ) {($0, $1, $2)}
            )
            .asSignal(onErrorJustReturn: ("", "", "")),
        
        nextButtonClikced: nextButton.rx.tap
            .withLatestFrom(
                Observable.combineLatest(
                    (yearTextField.rx.text.orEmpty),
                    (monthTextField.rx.text.orEmpty),
                    (dayTextField.rx.text.orEmpty)
                ) {($0, $1, $2)}
            )
            .asSignal(onErrorJustReturn: ("", "", ""))
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setPickerView()
        setConstraints()
        setDateComponents()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setComponents() {
        [textLabel, stackView, nextButton, blockingButton].forEach {
            view.addSubview($0)
        }
        [yearTextField, yearLabel, firstLineView, monthTextField, monthLabel, secondLineView, dayTextField, dayLabel, thirdLineView].forEach {
            stackView.addSubview($0)
        }
        setComponentsValue()
        setNavigation()
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.leading.equalTo(74)
            make.trailing.equalTo(-73)
            make.height.equalTo(64)
            make.bottom.equalTo(stackView.snp.top).inset(-80)
        }
        blockingButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(47)
            make.bottom.equalTo(nextButton.snp.top).inset(-72)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(47)
            make.bottom.equalTo(nextButton.snp.top).inset(-72)
        }
        yearTextField.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.equalTo(yearLabel.snp.leading).inset(-40)
        }
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(monthTextField.snp.leading).inset(-35)
            make.height.equalTo(26)
        }
        firstLineView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.trailing.equalTo(yearLabel.snp.leading).inset(-4)
        }
        monthTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.equalTo(monthLabel.snp.leading).inset(-64)
        }
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(dayTextField.snp.leading).inset(-35)
            make.height.equalTo(26)
        }
        secondLineView.snp.makeConstraints { make in
            make.leading.equalTo(firstLineView.snp.trailing).inset(-42)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.trailing.equalTo(monthLabel.snp.leading).inset(-4)
        }
        dayTextField.snp.makeConstraints { make in
            make.leading.equalTo(monthLabel.snp.trailing).inset(-35)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.equalTo(dayLabel.snp.leading).inset(-64)
        }
        dayLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.height.equalTo(26)
        }
        thirdLineView.snp.makeConstraints { make in
            make.leading.equalTo(secondLineView.snp.trailing).inset(-42)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.trailing.equalTo(dayLabel.snp.leading).inset(-4)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(347)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        textLabel.textAlignment = .center
        textLabel.text = SLPAssets.RawString.enterBirth.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        [firstLineView, secondLineView, thirdLineView].forEach {
            $0.backgroundColor = SLPAssets.CustomColor.gray3.color
        }
        
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle(SLPAssets.RawString.next.text, for: .normal)
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        setInitialTextAndPlaceholder()
    }
    
    private func setInitialTextAndPlaceholder() {
        yearLabel.text = "년"
        monthLabel.text = "월"
        dayLabel.text = "일"
        yearTextField.placeholder = "1990"
        monthTextField.placeholder = "1"
        dayTextField.placeholder = "1"
    }
    
    private func setDateComponents() {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year
        guard let year = year else { return }
        allYear = Array(1900...year).reversed()
    }
    
    private func setFirstResponder() {
        yearTextField.becomeFirstResponder()
    }
    
    private func setResignFirstResponder() {
        yearTextField.resignFirstResponder()
    }
    
    private func setPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        yearTextField.inputView = pickerView
        yearTextField.tintColor = .clear
    }
    
    private func setNextButtonAble() {
        nextButton.backgroundColor = SLPAssets.CustomColor.green.color
    }
    
    private func setNextButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func bind() {
        output.becomeFirstResponder
            .emit(onNext: { [weak self] _ in
                self?.setFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.ableNextButton
            .emit(onNext: { [weak self] check in
                check ? self?.setNextButtonAble() : self?.setNextButtonDisabled()
            })
            .disposed(by: disposeBag)
        
        output.showMailVC
            .emit(onNext: { [weak self] _ in
                let vc = EmailViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
                self?.setResignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        blockingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.setFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}

extension BirthViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return allYear.count
        case 1:
            return allMonth.count
        case 2:
            return allDay.count
        default:
            return 0
        }
    }
    
    //MARK: 너무 러프한 로직 -> 어떻게 효율적으로 수정할 수 있을까?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            yearTextField.text = String(allYear[row])
            yearTextField.text?.removeAll()
            yearTextField.insertText(String(allYear[row]))
        case 1:
            monthTextField.text = String(allMonth[row])
            monthTextField.text?.removeAll()
            monthTextField.insertText(String(allMonth[row]))
        case 2:
            dayTextField.text = String(allDay[row])
            dayTextField.text?.removeAll()
            dayTextField.insertText(String(allDay[row]))
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(allYear[row])년"
        case 1:
            return "\(allMonth[row])월"
        case 2:
            return "\(allDay[row])일"
        default:
            return ""
        }
    }
}
