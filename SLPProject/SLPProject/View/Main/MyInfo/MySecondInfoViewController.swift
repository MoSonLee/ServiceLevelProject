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
    
    private var toggle: Bool = false
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let sections = BehaviorRelay(value: [
        MySecondInfoTableSectionModel(header: "", items: [
            MySecondInfoTableModel(title: "김새싹", gender: nil, study: nil, switchType: nil, age: nil, slider: nil)
        ]),
        MySecondInfoTableSectionModel(header: "", items: [
            MySecondInfoTableModel(title: "내 성별", gender: 0, study: nil, switchType: nil, age: nil, slider: nil),
            MySecondInfoTableModel(title: "자주 하는 스터디", gender: nil, study: "", switchType: nil, age: nil, slider: nil),
            MySecondInfoTableModel(title: "내 번호 검색 허용", gender: nil, study: nil, switchType: false, age: nil, slider: nil),
            MySecondInfoTableModel(title: "상대방 연령대", gender: nil, study: nil, switchType: nil, age: "18-35", slider: nil),
            MySecondInfoTableModel(title: nil, gender: nil, study: nil, switchType: nil, age: nil, slider: ""),
            MySecondInfoTableModel(title: "회원탈퇴", gender: nil, study: nil, switchType: nil, age: nil, slider: nil)
        ])
    ])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bindTableView()
    }
    
    private func setNavigationItems() {
        
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
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySecondInfoTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { [weak self] data, tableView, indexPath, item in
            var cell = MyPageDetailViewCell()
            guard let self = self else { return cell }
            switch indexPath.section {
            case 0:
               cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageButtonCell.identifider, for: indexPath) as? ProfileImageButtonCell ?? MyPageDetailViewCell()
                guard let cell = cell as? ProfileImageButtonCell else { return MyPageDetailViewCell() }
                cell.showInfoButton.rx.tap
                    .subscribe(onNext: {
                        self.toggle = !self.toggle
                        cell.setExpand(toggle: self.toggle)
                        UIView.transition(
                            with: tableView,
                            duration: 0.35,
                            options: .transitionCrossDissolve,
                            animations: { self.tableView.reloadData()})
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.mannerButton.rx.tap
                    .subscribe(onNext: {
                        cell.mannerButtonClicked()
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.timeButton.rx.tap
                    .subscribe(onNext: {
                        cell.timeButtonClicked()
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.responseButton.rx.tap
                    .subscribe(onNext: {
                        cell.responseButtonClicked()
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.kindButton.rx.tap
                    .subscribe(onNext: {
                        cell.kindButtonClicked()
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.niceSkillButton.rx.tap
                    .subscribe(onNext: {
                        cell.skilButtonClicked()
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.niceTimeButton.rx.tap
                    .subscribe(onNext: {
                        cell.niceTimeButtonClicked()
                    })
                    .disposed(by: cell.disposeBag)
                
            case 1:
                switch indexPath.row {
                case 0:
                    cell = tableView.dequeueReusableCell(withIdentifier: GenderCell.identifider, for: indexPath) as? GenderCell ?? MyPageDetailViewCell()
                    guard let cell = cell as? GenderCell else { return MyPageDetailViewCell() }
                    cell.boyButton.rx.tap
                        .subscribe(onNext: {
                            cell.boyButtonClicked()
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.girlButton.rx.tap
                        .subscribe(onNext: {
                            cell.girlButtonClicked()
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
        
        sections
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
