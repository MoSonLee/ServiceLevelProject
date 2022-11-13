//
//  InitialViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class InitialViewController: UIViewController {
    
    private let splashImage = UIImageView()
    private let splashTextImage = UIImageView()
    
    private let viewModel = InitialViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    
    private lazy var input = InitialViewModel.Input(viewDidLoad: viewDidLoadEvent.asObservable())
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
        view.backgroundColor = .white
        [splashImage, splashTextImage].forEach {
            view.addSubview($0)
            $0.contentMode = .scaleAspectFit
        }
        setComponentsValue()
    }
    
    private func setComponentsValue() {
        splashImage.image = SLPAssets.CustomImage.splashImage.image
        splashTextImage.image = SLPAssets.CustomImage.splashTextImage.image
    }
    
    private func setConstraints() {
        splashImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(76)
            make.height.equalTo(264)
            make.bottom.equalTo(splashTextImage.snp.top).inset(-35.44)
        }
        splashTextImage.snp.makeConstraints { make in
            make.top.equalTo(splashImage.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(41)
            make.height.equalTo(101)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(197)
        }
    }
    
    private func bind() {
        output.showMainVC
            .emit(onNext: { [weak self] _ in
                let vc = MainViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showOnboardingVC
            .emit(onNext: { [weak self] _ in
                let vc = OnBoardingPageViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showLoginVC
            .emit(onNext: { [weak self] _ in
                let vc = LoginViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
            })
            .disposed(by: disposeBag)
    }
}
