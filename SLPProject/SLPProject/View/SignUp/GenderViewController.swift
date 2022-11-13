//
//  GenderViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class GenderViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private let textLabel = UILabel()
    private let subTextLabel = UILabel()
    private let boyButton = UIButton()
    private let girlButton = UIButton()
    private let nextButton = UIButton()
    
    private let viewModel = GenderViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var input = GenderViewModel.Input(
        backButtonTapped: backButton.rx.tap.asSignal(),
        boyButtonTapped: boyButton.rx.tap.asSignal(),
        girlButtonTapped: girlButton.rx.tap.asSignal(),
        nextButtonTapped: nextButton.rx.tap.asSignal()
    )
    
    private lazy var output = viewModel.transform(input: input)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        [textLabel, subTextLabel, boyButton, girlButton, nextButton].forEach {
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
            make.bottom.equalTo(boyButton.snp.top).inset(-32)
        }
        boyButton.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.height.equalTo(120)
            make.width.equalTo(166)
            make.bottom.equalTo(nextButton.snp.top).inset(-32)
        }
        girlButton.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(nextButton.snp.top).inset(-32)
            make.width.equalTo(166)
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
        textLabel.text = SLPAssets.RawString.selectGender.text
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        subTextLabel.text = SLPAssets.RawString.genderRequired.text
        subTextLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subTextLabel.textColor = SLPAssets.CustomColor.gray7.color
        subTextLabel.textAlignment = .center
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle(SLPAssets.RawString.next.text, for: .normal)
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        
        boyButton.setImage(SLPAssets.CustomImage.boyButton.image, for: .normal)
        girlButton.setImage(SLPAssets.CustomImage.girlButton.image, for: .normal)
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setBoyButtonHighlightened() {
        boyButton.backgroundColor = SLPAssets.CustomColor.whiteGreen.color
        girlButton.backgroundColor = SLPAssets.CustomColor.gray3.color
    }
    
    private func setGirlButtonHighlightened() {
        girlButton.backgroundColor = SLPAssets.CustomColor.whiteGreen.color
        boyButton.backgroundColor = SLPAssets.CustomColor.gray3.color
    }
    
    private func setNextButtonAble() {
        nextButton.backgroundColor = SLPAssets.CustomColor.green.color
    }
    
    private func setNextButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showMainVC
            .emit(onNext: { [weak self] _ in
                let vc = MainViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true)
                self?.changeRootViewController(nav)
            })
            .disposed(by: disposeBag)
        
        output.highlightBoyButton
            .emit(onNext: { [weak self] _ in
                self?.setBoyButtonHighlightened()
                self?.setNextButtonAble()
            })
            .disposed(by: disposeBag)
        
        output.highlightGirlButton
            .emit(onNext: { [weak self] _ in
                self?.setGirlButtonHighlightened()
                self?.setNextButtonAble()
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
            })
            .disposed(by: disposeBag)
        
        output.moveToNicknameVC
            .emit(onNext: { [weak self] _ in
                self?.showAlert(title: SLPAssets.RawString.invalidateNickname.text, okTitle: SLPAssets.RawString.confirm.text, completion: {
                    self?.navigationController?.popToViewController(of: NickNameViewController.self, animated: true)
                })
            })
            .disposed(by: disposeBag)
    }
}
