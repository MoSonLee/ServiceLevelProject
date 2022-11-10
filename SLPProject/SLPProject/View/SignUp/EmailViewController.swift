//
//  EmailViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class EmailViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let textLabel = UILabel()
    private let subTextLabel = UILabel()
    private let emailTextField = UITextField()
    private let lineView = UIView()
    private let nextButton = UIButton()
    
    private let viewModel = EmailViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var input = EmailViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        emailTextFieldCompleted: emailTextField.rx.text.orEmpty
            .withLatestFrom(
                emailTextField.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: ""),
        nextButtonTapped: nextButton.rx.tap
            .withLatestFrom(
                emailTextField.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: "")
    )
    
    private lazy var output = viewModel.transform(input: input)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setComponents() {
        [textLabel, subTextLabel, emailTextField, lineView, nextButton].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
        setNavigation()
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(168)
            make.leading.equalTo(94)
            make.trailing.equalTo(-93)
            make.height.equalTo(32)
            make.bottom.equalTo(subTextLabel.snp.top).inset(-8)
        }
        subTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(52)
            make.trailing.equalTo(-51)
            make.height.equalTo(26)
            make.bottom.equalTo(emailTextField.snp.top).inset(-76)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.bottom.equalTo(lineView.snp.top).inset(-12)
        }
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
            make.bottom.equalTo(nextButton.snp.top).inset(-72)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .center
        textLabel.text = SLPAssets.RawString.enterEmail.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        subTextLabel.text = SLPAssets.RawString.emailSubtext.text
        subTextLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subTextLabel.textColor = SLPAssets.CustomColor.gray7.color
        subTextLabel.textAlignment = .center
        
        emailTextField.placeholder = SLPAssets.RawString.emailPlaceholder.text
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
        
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle(SLPAssets.RawString.next.text, for: .normal)
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setNextButtonAble() {
        nextButton.backgroundColor = SLPAssets.CustomColor.green.color
        lineView.backgroundColor = SLPAssets.CustomColor.focus.color
    }
    
    private func setNextButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
    }
    
    private func setFirstResponder() {
        emailTextField.becomeFirstResponder()
        emailTextField.keyboardType = .decimalPad
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
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
                self?.emailTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.showGenerVC
            .emit(onNext: { [weak self] _ in
                let vc = GenderViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.ableNextButton
            .emit(onNext: { [weak self] check in
                check ? self?.setNextButtonAble() : self?.setNextButtonDisabled()
            })
            .disposed(by: disposeBag)
    }
}
