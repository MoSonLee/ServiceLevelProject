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
    
    private var userInfo = UserLoginInfo(id: "", v: 0, uid: "", phoneNumber: "", email: "", fcMtoken: "", nick: "", birth: "", gender: 0, study: "", comment: [""], reputation: [0], sesac: 0, sesacCollection: [0], background: 0, backgroundCollection: [0], purchaseToken: [""], transactionID: [""], reviewedBefore: [""], reportedNum: 0, reportedUser: [""], dodgepenalty: 0, dodgeNum: 0, ageMin: 0, ageMax: 0, searchable: 0, createdAt: "")
    
    private lazy var sections = BehaviorRelay(value: [
        MyInfoTableSectionModel(header: "", items: [
            MyInfoTableModel(buttonImageString: SLPAssets.RawString.profileImageString.text, title: userInfo.nick)
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
        sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        output.showMySecondInfoVC
            .emit { [weak self] indexPath in
                let vc = MySecondInfoViewController()
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
                self?.userInfo = data
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
