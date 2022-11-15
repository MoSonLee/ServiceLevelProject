//
//  MyInfoViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class MyInfoViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel = MyInfoViewModel()
    
    private let sections = BehaviorRelay(value: [
        MyInfoTableSectionModel(header: "", items: [
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.profileImageString.text, title: "이승후")
        ]),
        MyInfoTableSectionModel(header: "", items: [
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.noticeImageString.text,
                    title: SLPAssets.RawString.notice.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.faqImageString.text,
                    title: SLPAssets.RawString.noticeImageString.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.qnaImageString.text,
                    title: SLPAssets.RawString.faq.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.alarmImageString.text,
                    title: SLPAssets.RawString.qna.text),
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.permitImageString.text,
                    title: SLPAssets.RawString.permit.text)
        ])
    ])
    
    private lazy var input = MyInfoViewModel.Input(cellTapped: tableView.rx.itemSelected.asControlEvent())
    
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        view.addSubview(tableView)
        setComponentsValue()
        bindTableView()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(277)
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        tableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.identifider)
    }
    
    private func bindTableView() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<MyInfoTableSectionModel>(animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left)) { data, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoTableViewCell.identifider, for: indexPath) as? MyInfoTableViewCell else { return UITableViewCell() }
            cell.configure(indexPath: indexPath, item: item)
            return cell
        }
        
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        output.showMySecondInfoVC
            .emit { [weak self] index in
                let vc = MySecondInfoViewController()
                index == [0,0] ? self?.navigationController?.pushViewController(vc, animated: true) : nil
            }
            .disposed(by: disposeBag)
    }
}

extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 96 : 76
    }
}
