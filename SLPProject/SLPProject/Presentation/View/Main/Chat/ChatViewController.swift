//
//  ChatViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import UIKit

import RxCocoa
import RxSwift

final class ChatViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private var ellipsisButton = UIBarButtonItem()
    
    private let viewModel = ChatViewModel()
    private lazy var input = ChatViewModel.Input(
        backButtonTapped: backButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        setComponentsValue()
        setNavigation()
    }
    
    private func setComponentsValue() {
        view.backgroundColor = .white
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        ellipsisButton = UIBarButtonItem(image: SLPAssets.CustomImage.ellipsis.image, style: .plain, target: navigationController, action: nil)
        ellipsisButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = ellipsisButton
    }
    
    private func setConstraints() {
        
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
