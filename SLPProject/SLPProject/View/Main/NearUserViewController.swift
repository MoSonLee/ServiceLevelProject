//
//  NearUserViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/25.
//

import UIKit

import RxCocoa
import RxSwift

final class NearUserViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private var stopButton = UIBarButtonItem()
    
    private let viewModel = NearUserViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var input = NearUserViewModel.Input(
        backButtonTapped: backButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

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
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        stopButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopButton
    }
    
    private func setConstraints() { }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
