//
//  OnBoardingPageViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class OnBoardingPageViewController: UIViewController {
    
    private let startButton = UIButton()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageViewControllerList: [UIViewController] = []
    
    private let viewModel = OnBoardingViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var input = OnBoardingViewModel.Input(
        startButtonTapped: startButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        [startButton, pageViewController.view].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
        configurePageViewController()
    }
    
    private func setConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalToSuperview().inset(116)
            make.bottom.equalTo(startButton.snp.top).inset(-42)
        }
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = .white
        pageViewController.view.backgroundColor = .white
        startButton.backgroundColor = .green
        startButton.setTitle(SLPAssets.RawString.stratButtonTitle.text, for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.backgroundColor = SLPAssets.CustomColor.green.color
    }
    
    private func configurePageViewController() {
        pageViewControllerList = [FirstOnBoardingViewController(), SecondOnBoardingViewController(), ThirdOnBoardingViewController()]
        pageViewController.delegate = self
        pageViewController.dataSource = self
        guard let first = pageViewControllerList.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
        
        let proxy = UIPageControl.appearance()
        proxy.pageIndicatorTintColor = UIColor.systemGray
        proxy.currentPageIndicatorTintColor = UIColor.black
    }
    
    private func bind() {
        output.showLoginVC
            .emit(onNext: { [weak self] _ in
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .overFullScreen
                self?.present(nav, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension OnBoardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = pageViewController.viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        return index
    }
}
