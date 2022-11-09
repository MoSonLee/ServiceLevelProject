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
    
    private let textLabel = UILabel()
    private let stackView = UIStackView()
    private let yearTextField = UITextField()
    private let monthTextField = UITextField()
    private let dayTextField = UITextField()
    private let yearLabel = UILabel()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let firstLineView = UIView()
    private let secondLineView = UIView()
    private let thirdLineView = UIView()
    private let nextButton = UIButton()
    
    private let viewModel = BirthViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setComponents() {
        [textLabel, stackView, nextButton].forEach {
            view.addSubview($0)
        }
        [yearTextField, yearLabel, firstLineView, monthTextField, monthLabel, secondLineView, dayTextField, dayLabel, thirdLineView].forEach {
            stackView.addSubview($0)
        }
        setComponentsValue()
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.leading.equalTo(74)
            make.trailing.equalTo(-73)
            make.height.equalTo(64)
            make.bottom.equalTo(stackView.snp.top).inset(-80)
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
        
        [yearTextField, monthTextField, dayTextField].forEach {
            $0.isUserInteractionEnabled = false
        }
        
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle(SLPAssets.RawString.next.text, for: .normal)
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        
        yearLabel.text = "년"
        monthLabel.text = "월"
        dayLabel.text = "일"
    }
    
    private func setSendMessageButtonAble() {
        nextButton.backgroundColor = SLPAssets.CustomColor.green.color
    }
    
    private func setSendMessageButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func bind() {
        
    }
}
