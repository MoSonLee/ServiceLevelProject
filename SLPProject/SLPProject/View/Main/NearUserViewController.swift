//
//  NearUserViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/25.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class NearUserViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private var stopButton = UIBarButtonItem()
    
    private let nearButton = UIButton()
    private let receivedButton = UIButton()
    private let lineView = UIView()
    private let selecetedLineView = UIView()
    private let tableView = UITableView()
    
    private var currentStatus:SeSACTabModel = .near
    
    let viewModel = NearUserViewModel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var input = NearUserViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        nearButtonTapped: nearButton.rx.tap.asSignal(),
        receivedButtonTapped: receivedButton.rx.tap.asSignal()
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
        [nearButton, receivedButton, lineView, tableView].forEach {
            view.addSubview($0)
        }
        lineView.addSubview(selecetedLineView)
        
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
    
    private func setConstraints() {
        nearButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(45)
        }
        receivedButton.snp.makeConstraints { make in
            make.top.right.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(45)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nearButton.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(2)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        selecetedLineView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        nearButton.setTitle("주변 새싹", for: .normal)
        receivedButton.setTitle("받은 요청", for: .normal)
        nearButton.setTitleColor(SLPAssets.CustomColor.gray6.color, for: .normal)
        receivedButton.setTitleColor(SLPAssets.CustomColor.gray6.color, for: .normal)
        nearButton.setTitleColor(SLPAssets.CustomColor.green.color, for: .selected)
        receivedButton.setTitleColor(SLPAssets.CustomColor.green.color, for: .selected)
        selecetedLineView.backgroundColor = SLPAssets.CustomColor.green.color
        tableView.backgroundColor = .gray
    }
    
    private func selectedBarAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: { [weak self] in
            self?.selecetedLineView.transform = CGAffineTransform(translationX: moveX, y: 0)
        }, completion: nil)
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(onNext: { [weak self] selectedtab in
                switch selectedtab {
                case .near:
                    self?.currentStatus = .near
                    self?.nearButton.isSelected = true
                    self?.receivedButton.isSelected = false
                    self?.selectedBarAnimation(moveX: 0)
                case .receive:
                    self?.currentStatus = .receive
                    self?.receivedButton.isSelected = true
                    self?.nearButton.isSelected = false
                    self?.selectedBarAnimation(moveX: UIScreen.main.bounds.width / 2)
                }
            })
            .disposed(by: disposeBag)
    }
}
