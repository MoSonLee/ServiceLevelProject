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
import Toast

final class LoginViewController: UIViewController {
    
    private let textLabel = UILabel()
    private let phoneNumberTextField = UITextField()
    private let lineView = UIView()
    private let sendMessageButton = UIButton()
    private let viewModel = LoginViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var input = LoginViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        numberTextFieldChanged: phoneNumberTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: ""),
        
        numberTextFiledCompleted: phoneNumberTextField.rx.text.orEmpty
            .withLatestFrom(
                phoneNumberTextField.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: ""),
        
        sendMessageButtonTapped: sendMessageButton.rx.tap
            .withLatestFrom(
                phoneNumberTextField.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: ""),
        
        multipleTimeMessageButtonTapped: sendMessageButton.rx.tap.asSignal()
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
        view.backgroundColor = SLPAssets.CustomColor.white.color
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.text = SLPAssets.RawString.loginInitialText.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        phoneNumberTextField.placeholder = SLPAssets.RawString.certificationPlaceholderText.text
        phoneNumberTextField.delegate = self
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
        
        sendMessageButton.layer.cornerRadius = 8
        sendMessageButton.setTitle(SLPAssets.RawString.getCertificationMessage.text, for: .normal)
        sendMessageButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func setFirstResponder() {
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.keyboardType = .decimalPad
    }
    
    private func setSendMessageButtonAble() {
        sendMessageButton.backgroundColor = SLPAssets.CustomColor.green.color
        lineView.backgroundColor = SLPAssets.CustomColor.focus.color
    }
    
    private func setSendMessageButtonDisabled() {
        sendMessageButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
    }
    
    private func setTenNumberFormat() {
        guard let text = phoneNumberTextField.text else { return }
        phoneNumberTextField.text = text.applyPatternOnNumbers(pattern: "###-###-####", replacmentCharacter: "#")
    }
    
    private func setElevenNumberFormat() {
        guard let text = phoneNumberTextField.text else { return }
        phoneNumberTextField.text = text.applyPatternOnNumbers(pattern: "###-####-####", replacmentCharacter: "#")
    }
    
    private func bind() {
        output.becomeFirstResponder
            .emit(onNext: { [weak self] _ in
                self?.setFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.changeToFormatNumber
            .emit(onNext: { [weak self] check in
                check ? self?.setElevenNumberFormat() : self?.setTenNumberFormat()
            })
            .disposed(by: disposeBag)
        
        output.ableMessageButton
            .emit(onNext: { [weak self] check in
                check ? self?.setSendMessageButtonAble() : self?.setSendMessageButtonDisabled()
            })
            .disposed(by: disposeBag)
        
        output.showCertificationVC
            .emit(onNext: { [weak self] check in
                if check {
                    let vc = CertificationViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
            })
            .disposed(by: disposeBag)
        
        output.checkMultipleTapped
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: 여길 어떻게 뺼 수 있을까
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = "-1234567890"
        let allowedCharcterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharcterSet = CharacterSet(charactersIn: string)
        if  allowedCharcterSet.isSuperset(of: typedCharcterSet)
                , count <= 13 {
            return true
        } else {
            return false
        }
    }
}
