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
    
    private lazy var input = MyInfoViewModel.Input(cellTapped: tableView.rx.itemSelected.asSignal())
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        getUserInfo()
        bind()
    }
    
    private func setComponents() {
        view.addSubview(tableView)
        setComponentsValue()
        navigationItem.title = "내정보"
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(-24)
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
            cell.selectionStyle = .none
            cell.configure(indexPath: indexPath, item: item)
            return cell
        }
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        output.showMySecondInfoVC
            .emit { [weak self] indexPath in
                let vc = MySecondInfoViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 96 : 76
    }
}

extension MyInfoViewController {
    private func getUserInfo() {
        APIService().responseGetUser { [weak self] result in
            switch result {
            case .success(let response):
                let data = try! JSONDecoder().decode(UserLoginInfo.self, from: response.data)
                self?.viewModel.userInfo = data
                self?.bindTableView()
                
            case .failure(let error):
                let error = SLPLoginError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                print(error)
            }
        }
    }
}
