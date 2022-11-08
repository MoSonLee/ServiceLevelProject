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
    private let lineView = UIView()
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
        [textLabel, lineView, nextButton].forEach {
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
            make.bottom.equalTo(lineView.snp.top).inset(-77)
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
        
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
        
        nextButton.layer.cornerRadius = 8
        nextButton.setTitle(SLPAssets.RawString.next.text, for: .normal)
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
    }
    
    private func setSendMessageButtonAble() {
        nextButton.backgroundColor = SLPAssets.CustomColor.green.color
        lineView.backgroundColor = SLPAssets.CustomColor.focus.color
    }
    
    private func setSendMessageButtonDisabled() {
        nextButton.backgroundColor = SLPAssets.CustomColor.gray6.color
        lineView.backgroundColor = SLPAssets.CustomColor.gray3.color
    }
    
    private func bind() {
        
    }
        
}
