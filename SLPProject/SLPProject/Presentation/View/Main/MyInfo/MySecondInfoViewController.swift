//
//  MySecondInfoViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class MySecondInfoViewController: UIViewController {
    
    private var completeButton = UIBarButtonItem()
    private var backButton = UIBarButtonItem()
    private var toggle: Bool = false
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel = MySecondInfoViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        setComponents()
        setNavigationItems()
        setConstraints()
    }
    
    private func setNavigationItems() {
        navigationItem.title = "정보관리"
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        completeButton = UIBarButtonItem(title: "저장", style: .plain, target: navigationController, action: nil)
        completeButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = completeButton
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setComponents() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        setComponentsValue()
    }
    
    private func setComponentsValue() {
        tableView.register(ProfileImageButtonCell.self, forCellReuseIdentifier: ProfileImageButtonCell.identifider)
        tableView.register(GenderCell.self, forCellReuseIdentifier: GenderCell.identifider)
        tableView.register(StudyCell.self, forCellReuseIdentifier: StudyCell.identifider)
        tableView.register(NumberCell.self, forCellReuseIdentifier: NumberCell.identifider)
        tableView.register(AgeCell.self, forCellReuseIdentifier: AgeCell.identifider)
        tableView.register(DoubleSliderCell.self, forCellReuseIdentifier: DoubleSliderCell.identifider)
        tableView.register(WithdrawCell.self, forCellReuseIdentifier: WithdrawCell.identifider)
    }
    
    private func setConstraints() {
        [tableView].forEach {
            view.addSubview($0)
        }
        tableView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func bindTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySecondInfoTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { [weak self] data, tableView, indexPath, item in
            var cell = MyPageDetailViewCell()
            guard let self = self else { return cell }
            switch indexPath.section {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageButtonCell.identifider, for: indexPath) as? ProfileImageButtonCell ?? MyPageDetailViewCell()
                guard let cell = cell as? ProfileImageButtonCell else { return MyPageDetailViewCell() }
                cell.setExpand(toggle: self.toggle)
                cell.showInfoButton.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.toggle = !(self.toggle)
                        self.tableView.reloadData()
                    })
                    .disposed(by: cell.disposeBag)
                
            case 1:
                switch indexPath.row {
                case 0:
                    cell = tableView.dequeueReusableCell(withIdentifier: GenderCell.identifider, for: indexPath) as? GenderCell ?? MyPageDetailViewCell()
                    guard let cell = cell as? GenderCell else { return MyPageDetailViewCell() }
                    self.viewModel.userInfo.gender == 0 ? cell.girlButtonClicked() : cell.boyButtonClicked()
                    cell.boyButton.rx.tap
                        .subscribe(onNext: {
                            cell.boyButtonClicked()
                            self.viewModel.userInfo.gender = 1
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.girlButton.rx.tap
                        .subscribe(onNext: {
                            cell.girlButtonClicked()
                            self.viewModel.userInfo.gender = 1
                        })
                        .disposed(by: cell.disposeBag)
                    
                case 1:
                    cell = tableView.dequeueReusableCell(withIdentifier: StudyCell.identifider, for: indexPath) as? StudyCell ?? MyPageDetailViewCell()
                case 2:
                    cell = tableView.dequeueReusableCell(withIdentifier: NumberCell.identifider, for: indexPath) as? NumberCell ?? MyPageDetailViewCell()
                case 3:
                    cell = tableView.dequeueReusableCell(withIdentifier: AgeCell.identifider, for: indexPath) as? AgeCell ?? MyPageDetailViewCell()
                case 4:
                    cell = tableView.dequeueReusableCell(withIdentifier: DoubleSliderCell.identifider, for: indexPath) as? DoubleSliderCell ?? MyPageDetailViewCell()
                    
                case 5:
                    cell = tableView.dequeueReusableCell(withIdentifier: WithdrawCell.identifider, for: indexPath) as? WithdrawCell ?? MyPageDetailViewCell()
                    guard let cell = cell as? WithdrawCell else { return MyPageDetailViewCell() }
                    cell.withdrawButton.rx.tap
                        .subscribe(onNext: {
                            self.withdrawUser()
                        })
                        .disposed(by: cell.disposeBag)
                    
                default:
                    print("Error")
                }
                
            default:
                print("Error")
            }
            cell.configure(indexPath: indexPath, item: item)
            cell.selectionStyle = .none
            return cell
        }
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension MySecondInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0  ? UITableView.automaticDimension : 48
    }
}

extension MySecondInfoViewController {
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    private func withdrawUser() {
        showAlertWithCancel(title: "정말 탈퇴하시겠습니까?", okTitle: "확인", completion: {
            APIService().withdrawUser {[weak self] result in
                switch result {
                case .success(_):
                    self?.resetDefaults()
                    let nav = UINavigationController(rootViewController: OnBoardingPageViewController())
                    self?.changeRootViewController(nav)
                    self?.navigationController?.popToRootViewController(animated: true)
                    
                case .failure(let error):
                    let error = SLPWithdrawError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                    switch error {
                    case .tokenError:
                        print(SLPWithdrawError.tokenError)
                        
                    case .unRegisteredUser:
                        print(SLPWithdrawError.unRegisteredUser)
                        
                    case .serverError:
                        print(SLPWithdrawError.serverError)
                        
                    case .clientError:
                        print(SLPWithdrawError.clientError)
                        
                    case .unknown:
                        print(SLPWithdrawError.unknown)
                    }
                }
            }
        })
    }
    
    private func getUserInfo() {
        APIService().responseGetUser { [weak self] result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(UserLoginInfo.self, from: response.data)
                self?.viewModel.userInfo = data
                self?.bindTableView()
                
            case .failure(let error):
                let error = SLPLoginError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .tokenError:
                    print(SLPLoginError.tokenError)
                    
                case .unRegisteredUser:
                    print(SLPLoginError.unRegisteredUser)
                    
                case .serverError:
                    print(SLPLoginError.serverError)
                    
                case .clientError:
                    print(SLPLoginError.clientError)
                    
                case .unknown:
                    print(SLPLoginError.unknown)
                }
            }
        }
    }
}
