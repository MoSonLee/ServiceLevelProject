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
import Toast

final class NearUserViewController: UIViewController {
    
    let viewModel = NearUserViewModel()
    
    private var backButton = UIBarButtonItem()
    private var stopButton = UIBarButtonItem()
    private var currentStatus: SeSACTabModel = .near
    private var toggle: Bool = false
    
    private let nearButton = UIButton()
    private let receivedButton = UIButton()
    private let lineView = UIView()
    private let selecetedLineView = UIView()
    private let requestTableView = UITableView()
    private let acceptTableView = UITableView()
    private let backgroundView = UIView()
    private let backgroundImage = UIImageView()
    private let backgroundLabel = UILabel()
    private let backgroundSubLabel = UILabel()
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private lazy var input = NearUserViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        nearButtonTapped: nearButton.rx.tap.asSignal(),
        receivedButtonTapped: receivedButton.rx.tap.asSignal(),
        stopButtonTapped: stopButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private var requestSection = BehaviorRelay(value: [
        NearSeSACTableSectionModel(header: "", items: [
        ])
    ])
    
    private var acceptSection = BehaviorRelay(value: [
        NearSeSACTableSectionModel(header: "", items: [
        ])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        bindFirstTableView()
        bindSecondTableView()
        viewDidLoadEvent.accept(())
    }
    
    private func setComponents() {
        [nearButton, receivedButton, lineView, requestTableView, acceptTableView].forEach {
            view.addSubview($0)
        }
        [backgroundLabel, backgroundSubLabel, backgroundImage].forEach {
            backgroundView.addSubview($0)
        }
        lineView.addSubview(selecetedLineView)
        registerTableView()
        setComponentsValue()
        setNavigation()
    }
    
    private func registerTableView() {
        requestTableView.register(ProfileImageButtonCell.self, forCellReuseIdentifier: ProfileImageButtonCell.identifider)
        requestTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        acceptTableView.register(ProfileImageButtonCell.self, forCellReuseIdentifier: ProfileImageButtonCell.identifider)
        acceptTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = false
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        stopButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopButton
    }
    
    private func setRequestTableView() {
        acceptTableView.removeFromSuperview()
        view.addSubview(requestTableView)
        requestTableView.separatorStyle = .none
        requestTableView.backgroundColor = .clear
        requestTableView.showsVerticalScrollIndicator = false
        requestTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setAcceptTableView() {
        requestTableView.removeFromSuperview()
        view.addSubview(acceptTableView)
        acceptTableView.separatorStyle = .none
        acceptTableView.backgroundColor = .clear
        acceptTableView.showsVerticalScrollIndicator = false
        acceptTableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
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
        selecetedLineView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        backgroundImage.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(156.5)
            make.right.equalToSuperview().offset(-154.5)
        }
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImage.snp.bottom).offset(-32)
            make.left.equalToSuperview().offset(57)
            make.right.equalToSuperview().offset(-55)
            make.height.equalTo(32)
        }
        backgroundSubLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(-8)
            make.left.equalToSuperview().offset(56)
            make.right.equalToSuperview().offset(-54)
            make.height.equalTo(22)
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
        backgroundLabel.text = currentStatus.emptyViewMain
        backgroundSubLabel.text = currentStatus.emptyViewSub
        backgroundLabel.textColor = SLPAssets.CustomColor.black.color
        backgroundSubLabel.textColor = SLPAssets.CustomColor.gray7.color
        backgroundLabel.font = .systemFont(ofSize: 20)
        backgroundSubLabel.font = .systemFont(ofSize: 14)
        backgroundImage.image = SLPAssets.CustomImage.sprout.image
    }
    
    private func selectedBarAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .allowUserInteraction, animations: { [weak self] in
            self?.selecetedLineView.transform = CGAffineTransform(translationX: moveX, y: 0)
        }, completion: nil)
    }
    
    private func setTableViewBackground(check: Bool) {
        requestTableView.backgroundView = check ? nil : backgroundView
    }
    
    private func bindFirstTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<NearSeSACTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { [weak self] data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageButtonCell.identifider, for: indexPath) as? ProfileImageButtonCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureToNear(indexPath: indexPath, item: item)
            self?.setShowInfoTapped(cell: cell, indexPath: indexPath)
            cell.configureRequestButton()
            cell.requestOrGetButton.rx.tap
                .subscribe(onNext: {
                    self?.showAlertWithCancel(title: "스터디를 요청할게요", okTitle: "확인", completion: {
                        self?.viewModel.studyRequest(index: indexPath.row)
                    })
                })
                .disposed(by: cell.disposeBag)
            return cell
        }
        requestSection
            .bind(to: requestTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindSecondTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<NearSeSACTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { [weak self] data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageButtonCell.identifider, for: indexPath) as? ProfileImageButtonCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureToNear(indexPath: indexPath, item: item)
            self?.setShowInfoTapped(cell: cell, indexPath: indexPath)
            cell.configureRequestButton()
            cell.configureGetButton()
            cell.requestOrGetButton.rx.tap
                .subscribe(onNext: {
                    self?.showAlertWithCancel(title: "스터디를 수락할까요?", okTitle: "확인", completion: {
                        self?.viewModel.acceptStudy(index: indexPath.row)
                    })
                })
                .disposed(by: cell.disposeBag)
            return cell
        }
        acceptSection
            .bind(to: acceptTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setShowInfoTapped(cell: ProfileImageButtonCell, indexPath: IndexPath) {
        cell.showInfoButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.toggle = !(self?.toggle ?? false)
                cell.setExpand(toggle: self?.toggle ?? false)
                UIView.transition(
                    with: self?.requestTableView ?? UIView(),
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: { self?.requestTableView.reloadRows(at:[indexPath], with: .fade)})
            })
            .disposed(by: cell.disposeBag)
    }
    
    private func setNearTabValues() {
        currentStatus = .near
        nearButton.isSelected = true
        receivedButton.isSelected = false
        selectedBarAnimation(moveX: 0)
        setRequestTableView()
    }
    
    private func setReceivedTabValues() {
        currentStatus = .receive
        receivedButton.isSelected = true
        nearButton.isSelected = false
        selectedBarAnimation(moveX: UIScreen.main.bounds.width / 2)
        setAcceptTableView()
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.checkDataCount
            .emit(onNext: { [weak self] check in
                self?.setTableViewBackground(check: check)
            })
            .disposed(by: disposeBag)
        
        output.selectedTab
            .drive(onNext: { [weak self] selectedtab in
                switch selectedtab {
                case .near:
                    self?.setNearTabValues()
                case .receive:
                    self?.setReceivedTabValues()
                }
            })
            .disposed(by: disposeBag)
        
        output.getTableViewData
            .emit(onNext: { [weak self] model in
                guard let requestSection = self?.requestSection else { return }
                self?.viewModel.acceptSectionValue(model: model, section: requestSection)
            })
            .disposed(by: disposeBag)
        
        output.getrequested
            .emit(onNext: { [weak self] model in
                guard let acceptSection = self?.acceptSection else { return }
                self?.viewModel.acceptSectionValue(model: model, section: acceptSection)
            })
            .disposed(by: disposeBag)
        
        output.moveToChatVC
            .emit(onNext: { [weak self] _ in
                let vc = ChatViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.showToast
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text)
            })
            .disposed(by: disposeBag)
        
        output.changeRootVC
            .emit(onNext: { [weak self] _ in
                let vc = HomeTabViewController()
                let nav = UINavigationController(rootViewController: vc)
                self?.changeRootViewController(nav)
            })
            .disposed(by: disposeBag)
    }
}

extension NearUserViewController: UITableViewDelegate {}
