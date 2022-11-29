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
    private let containerView = UIView()
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
    private let datePicker = UIDatePicker()
    
    private let viewModel = BirthViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var input = BirthViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        datePickerValueChanged: datePicker.rx.date.asSignal(onErrorJustReturn: Date()),
        nextButtonClikced: nextButton.rx.tap
            .withLatestFrom(datePicker.rx.date)
            .asSignal(onErrorJustReturn: Date())
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setPickerView()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setComponents() {
        [textLabel, containerView, nextButton, blockingButton].forEach {
            view.addSubview($0)
        }
        [yearTextField, yearLabel, firstLineView, monthTextField, monthLabel, secondLineView, dayTextField, dayLabel, thirdLineView].forEach {
            containerView.addSubview($0)
        }
        setComponentsValue()
        setNavigation()
        setDatePicker()
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.leading.equalTo(74)
            make.trailing.equalTo(-73)
            make.height.equalTo(64)
            make.bottom.equalTo(containerView.snp.top).inset(-80)
        }
        blockingButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(47)
            make.bottom.equalTo(nextButton.snp.top).inset(-72)
        }
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(47)
            make.bottom.equalTo(nextButton.snp.top).inset(-72)
        }
        yearTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
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
            make.trailing.equalTo(monthLabel.snp.leading).inset(-56)
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
            make.trailing.equalTo(dayLabel.snp.leading).inset(-56)
        }
        dayLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.height.equalTo(26)
            make.trailing.equalToSuperview()
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
    
    private func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    private func setFirstResponder() {
        yearTextField.becomeFirstResponder()
    }
    
    private func setResignFirstResponder() {
        yearTextField.resignFirstResponder()
    }
    
    private func setPickerView() {
        yearTextField.inputView = datePicker
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
        
        output.setBirthData
            .emit(onNext: { [weak self] texts in
                self?.yearTextField.text = texts.0
                self?.monthTextField.text = texts.1
                self?.dayTextField.text = texts.2
            })
            .disposed(by: disposeBag)
   
        blockingButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.setFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}
