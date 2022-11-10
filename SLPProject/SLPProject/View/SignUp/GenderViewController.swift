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
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var input = GenderViewModel.Input(
        
    )
    
    //    private lazy var output = viewModel.transform(input: input)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        viewDidLoadEvent.accept(())
    }
    
    private func setComponents() {
        [textLabel, subTextLabel, boyButton,girlButton, nextButton].forEach {
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
            //            make.bottom.equalTo(emailTextField.snp.top).inset(-76)
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
    }
    
    private func setNextButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    private func bind() { }
}
