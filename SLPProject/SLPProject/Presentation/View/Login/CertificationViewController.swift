//
//  CertificationViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class CertificationViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let textLabel = UILabel()
    private let certificationTextField = UITextField()
    private let lineView = UIView()
    private let startButton = UIButton()
    private let resendButton = UIButton()
    
    private let viewModel = CertificationViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var input = CertificationViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        certificationTextFieldCompleted: certificationTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: ""),
        startButtonTapped: startButton.rx.tap
            .withLatestFrom(
                certificationTextField.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: ""),
        resendButtonTapped: resendButton.rx.tap.asSignal(),
        multipleTimeResendButtonTapped: resendButton.rx.tap.asSignal(),
        multipleTimeCertificationButtonTapped: startButton.rx.tap.asSignal()
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
        [textLabel, certificationTextField, lineView, startButton, resendButton].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
        setNavigation()
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(168)
            make.leading.equalToSuperview().inset(57.5)
            make.trailing.equalToSuperview().inset(57.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
            make.bottom.equalTo(certificationTextField.snp.top).inset(-110)
        }
        
        certificationTextField.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
            make.bottom.equalTo(lineView.snp.top).inset(-12)
        }
        
        resendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(72)
            make.centerY.equalTo(certificationTextField.snp.centerY)
            make.bottom.equalTo(startButton.snp.top).inset(-74)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(resendButton.snp.leading).inset(-8)
            make.height.equalTo(1)
            make.bottom.equalTo(startButton.snp.top).inset(-72)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(48)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.text = SLPAssets.RawString.loginSecondaryText.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        certificationTextField.placeholder = SLPAssets.RawString.wrtieCertificationCode.text
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
        
        resendButton.layer.cornerRadius = 8
        resendButton.setTitle(SLPAssets.RawString.resendText.text, for: .normal)
        resendButton.backgroundColor = SLPAssets.CustomColor.green.color
        
        startButton.layer.cornerRadius = 8
        startButton.setTitle(SLPAssets.RawString.getCertificationMessageSecondary.text, for: .normal)
        startButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        startButton.isEnabled = false
    }
    
    private func setFirstResponder() {
        certificationTextField.becomeFirstResponder()
        certificationTextField.keyboardType = .decimalPad
    }
    
    private func setStartButtonAble() {
        startButton.backgroundColor = SLPAssets.CustomColor.green.color
        startButton.isEnabled = true
        lineView.backgroundColor = SLPAssets.CustomColor.focus.color
    }
    
    private func setStartButtonDisabled() {
        startButton.isEnabled = false
        startButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
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
        
        output.ableStartButton
            .emit(onNext: { [weak self] check in
                check ? self?.setStartButtonAble() : self?.setStartButtonDisabled()
            })
            .disposed(by: disposeBag)
        
        output.showSingUpVC
            .emit(onNext: { [weak self] _ in
                let vc = NickNameViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showMainVC
            .emit(onNext: { [weak self] _ in
                let vc = MainTabViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
                self?.certificationTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.changeRootViewToMain
            .emit(onNext: { [weak self] _ in
                let vc = MainTabViewController()
                self?.changeRootViewController(vc)
            })
            .disposed(by: disposeBag)
        
        output.changeRootViewToNickname
            .emit(onNext: { [weak self] _ in
                let vc = NickNameViewController()
                let nav = UINavigationController(rootViewController: vc)
                self?.changeRootViewController(nav)
            })
            .disposed(by: disposeBag)
    }
}

