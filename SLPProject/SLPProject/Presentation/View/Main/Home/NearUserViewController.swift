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
    private let tableView2 = UITableView()
    
    private let backgroundView = UIView()
    private let backgroundImage = UIImageView()
    private let backgroundLabel = UILabel()
    private let backgroundSubLabel = UILabel()
    
    private var currentStatus: SeSACTabModel = .near
    private var toggle: Bool = false
    
    let viewModel = NearUserViewModel()
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
    
    var sections = BehaviorRelay(value: [
        NearSeSACTableSectionModel(header: "", items: [
        ])
    ])
    
    var sections2 = BehaviorRelay(value: [
        NearSeSACTableSectionModel(header: "", items: [
            NearSeSACTableModel(backGroundImage: 0, title: "AA", reputation: [], studyList: [], review: [])
        ])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
        bindTableView()
        viewDidLoadEvent.accept(())
    }
    
    private func setComponents() {
        [nearButton, receivedButton, lineView, tableView, tableView2].forEach {
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
        tableView.register(ProfileImageButtonCell.self, forCellReuseIdentifier: ProfileImageButtonCell.identifider)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView2.register(ProfileImageButtonCell.self, forCellReuseIdentifier: ProfileImageButtonCell.identifider)
        tableView2.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        stopButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopButton
    }
    
    private func setTableView() {
        tableView2.removeFromSuperview()
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func setTableView2() {
        tableView.removeFromSuperview()
        view.addSubview(tableView2)
        tableView2.separatorStyle = .none
        tableView2.backgroundColor = .clear
        tableView2.showsVerticalScrollIndicator = false
        tableView2.snp.makeConstraints { make in
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
        !check ? tableView.backgroundView = backgroundView : nil
    }
    
    private func bindTableView() {
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<NearSeSACTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { [weak self] data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageButtonCell.identifider, for: indexPath) as? ProfileImageButtonCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureToNear(indexPath: indexPath, item: item)
            self?.setShowInfoTapped(cell: cell, indexPath: indexPath)
            switch self?.currentStatus {
            case .near:
                cell.configureRequestButton()
                cell.requestOrGetButton.rx.tap
                    .subscribe(onNext: {
                        self?.showAlertWithCancel(title: "스터디를 요청할게요", okTitle: "확인", completion: {
                            self?.viewModel.studyRequest(index: indexPath.row)
                        })
                    })
                    .disposed(by: cell.disposeBag)
                
            case .receive:
                cell.configureGetButton()
                cell.requestOrGetButton.rx.tap
                    .subscribe(onNext: {
                        self?.showAlertWithCancel(title: "스터디를 수락할까요?", okTitle: "확인", completion: {
                            self?.viewModel.acceptStudy(index: indexPath.row)
                        })
                    })
                    .disposed(by: cell.disposeBag)
                
            default:
                print("error")
            }
            return cell
        }
        
        switch currentStatus {
        case .near:
            sections
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        case .receive:
            sections2
                .bind(to: tableView2.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
        }
    }
    
    private func setShowInfoTapped(cell: ProfileImageButtonCell, indexPath: IndexPath) {
        cell.showInfoButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.toggle = !(self?.toggle ?? false)
                cell.setExpand(toggle: self?.toggle ?? false)
                UIView.transition(
                    with: self?.tableView ?? UIView(),
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: { self?.tableView.reloadRows(at:[indexPath], with: .fade)})
            })
            .disposed(by: cell.disposeBag)
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
                    self?.currentStatus = .near
                    self?.nearButton.isSelected = true
                    self?.receivedButton.isSelected = false
                    self?.selectedBarAnimation(moveX: 0)
                    self?.setTableView()
                    
                case .receive:
                    self?.currentStatus = .receive
                    self?.receivedButton.isSelected = true
                    self?.nearButton.isSelected = false
                    self?.selectedBarAnimation(moveX: UIScreen.main.bounds.width / 2)
                    self?.setTableView2()
                }
            })
            .disposed(by: disposeBag)
        
        output.getTableViewData
            .emit(onNext: { [weak self] model in
                var array = self?.sections.value
                array?[0].items.append(model)
                guard let array = array else { return }
                self?.sections.accept(array)
            })
            .disposed(by: disposeBag)
        
        output.getrequested
            .emit(onNext: { [weak self] model in
                var array = self?.sections2.value
                array?[0].items.append(model)
                guard let array = array else { return }
                self?.sections2.accept(array)
            })
            .disposed(by: disposeBag)
        
        output.moveToChatVC
            .emit(onNext: { [weak self] _ in
                let vc = ChatViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension NearUserViewController: UITableViewDelegate { }
