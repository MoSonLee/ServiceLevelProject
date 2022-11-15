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
    
    private let profileImage = UIImageView()
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
        profileImage.image = SLPAssets.CustomImage.myInfoProfile.image
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 8
        setComponentsValue()
    }
    
    private func setComponentsValue() {
        tableView.register(MySecondInfoTableViewCell.self, forCellReuseIdentifier: MySecondInfoTableViewCell.identifider)
    }
    
    private func setConstraints() {
        [profileImage, tableView].forEach {
            view.addSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(194)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(profileImage.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
    
    private func bindTableView() {
        tableView.separatorStyle = .none
        let dataSource = RxTableViewSectionedAnimatedDataSource<MySecondInfoTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MySecondInfoTableViewCell.identifider, for: indexPath) as? MySecondInfoTableViewCell else { return UITableViewCell() }
            cell.setConstraints(indexPath: indexPath)
            cell.configure(indexPath: indexPath, item: item)
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
        indexPath.section == 0 ? 78 : 65
    }
}
