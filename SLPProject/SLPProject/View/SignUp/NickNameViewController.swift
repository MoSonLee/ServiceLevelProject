//
//  NickNameViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class NickNameViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let textLabel = UILabel()
    private let nickcNameTextField = UITextField()
    private let lineView = UIView()
    private let nextButton = UIButton()
    private let viewModel = NickNameViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var input = NickNameViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        nickNameTextFieldCompleted: nickcNameTextField.rx.text.orEmpty
            .withLatestFrom(
                nickcNameTextField.rx.text.orEmpty
            )
            .asSignal(onErrorJustReturn: ""),
        nextButtonTapped: nextButton.rx.tap
            .withLatestFrom(
            nickcNameTextField.rx.text.orEmpty
        )
            .asSignal(onErrorJustReturn: "")
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
        [textLabel, nickcNameTextField, lineView, nextButton].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
        if !UserDefaults.verified {
            setNavigation()
        }
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.leading.equalTo(74)
            make.trailing.equalTo(-73)
            make.height.equalTo(64)
            make.bottom.equalTo(nickcNameTextField.snp.top).inset(-77)
        }
        
        nickcNameTextField.snp.makeConstraints { make in
            make.leading.equalTo(28)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(22)
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
            make.bottom.equalToSuperview().inset(347)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.text = SLPAssets.RawString.enterNickName.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        nickcNameTextField.placeholder = SLPAssets.RawString.writeTenLetters.text
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
        
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle(SLPAssets.RawString.next.text, for: .normal)
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func setFirstResponder() {
        nickcNameTextField.becomeFirstResponder()
    }
    
    private func setNextButtonAble() {
        nextButton.backgroundColor = SLPAssets.CustomColor.green.color
        lineView.backgroundColor = SLPAssets.CustomColor.focus.color
    }
    
    private func setNextButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
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
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
                self?.nickcNameTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        output.showBirthVC
            .emit(onNext: { [weak self] _ in
                let vc = BirthViewController()
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
