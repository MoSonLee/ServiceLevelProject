//
//  LoginViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class LoginViewController: UIViewController {
    
    private let textLabel = UILabel()
    private let phoneNumberTextField = UITextField()
    private let lineView = UIView()
    private let sendMessageButton = UIButton()
    
    private let viewModel = LoginViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var input = LoginViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        numberTextFiledCompleted: phoneNumberTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: ""),
        sendMessageButtonTapped: sendMessageButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setComponents() {
        [textLabel, phoneNumberTextField, lineView, sendMessageButton].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.leading.equalTo(74)
            make.trailing.equalTo(-73)
            make.height.equalTo(64)
            make.bottom.equalTo(phoneNumberTextField.snp.top).inset(-77)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
            make.bottom.equalTo(lineView.snp.top).inset(-12)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
            make.bottom.equalTo(sendMessageButton.snp.top).inset(-72)
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(347)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = .white
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.text = SLPAssets.RawString.loginInitialText.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        phoneNumberTextField.placeholder = SLPAssets.RawString.certificationPlaceholderText.text
        lineView.backgroundColor = SLPAssets.CustomColor.grey3.color
        
        sendMessageButton.layer.cornerRadius = 8
        sendMessageButton.setTitle(SLPAssets.RawString.getCertificationMessage.text, for: .normal)
        sendMessageButton.backgroundColor = SLPAssets.CustomColor.disabledGrey.color
        sendMessageButton.isEnabled = false
    }
    
    private func setFirstResponder() {
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.keyboardType = .decimalPad
    }
    
    private func setSendMessageButtonAble() {
        sendMessageButton.backgroundColor = SLPAssets.CustomColor.green.color
        sendMessageButton.isEnabled = true
        lineView.backgroundColor = SLPAssets.CustomColor.focus.color
    }
    
    private func setSendMessageButtonDisabled() {
        sendMessageButton.isEnabled = false
        sendMessageButton.backgroundColor = SLPAssets.CustomColor.disabledGrey.color
        lineView.backgroundColor = SLPAssets.CustomColor.grey3.color
    }
    
    private func bind() {
        output.becomeFirstResponder
            .emit(onNext: { [weak self] _ in
                self?.setFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.ableMessageButton
            .emit(onNext: { [weak self] check in
                check ? self?.setSendMessageButtonAble() : self?.setSendMessageButtonDisabled()
            })
            .disposed(by: disposeBag)
        
        output.showCertificationVC
            .emit(onNext: { [weak self] _ in
                let vc = CertificationViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
