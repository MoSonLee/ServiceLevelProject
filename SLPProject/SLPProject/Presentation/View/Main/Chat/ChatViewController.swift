//
//  ChatViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class ChatViewController: UIViewController {
    
    private var backButton = UIBarButtonItem()
    private var ellipsisButton = UIBarButtonItem()
    
    private let tableView = UITableView()
    private let textField = CustomTextField()
    private let sendButton = UIButton()
    
    private let viewDidLoadEvent = PublishRelay<Void>()
    private let viewDidDisapperEvent = PublishRelay<Void>()
    
    private let viewModel = ChatViewModel()
    private lazy var input = ChatViewModel.Input(
        viewDidLoad: viewDidLoadEvent.asObservable(),
        backButtonTapped: backButton.rx.tap.asSignal(),
        sendButtonTapped: sendButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty).asSignal(onErrorJustReturn: ""),
        textFieldValue: textField.rx.text
            .withLatestFrom(textField.rx.text.orEmpty)
            .asSignal(onErrorJustReturn: ""),
        tapped: ellipsisButton.rx.tap
            .withLatestFrom(textField.rx.text.orEmpty).asSignal(onErrorJustReturn: ""),
        viewDidDisapper: viewDidDisapperEvent.asObservable()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    private var chattingSection = BehaviorRelay(value: [
        ChatTableSectionModel(header: "", items: [
            ChatTableModel(title: "ㅁㅇㄴㅇㄴㅁㅁㅇㄴㅁㄴㅇ", userId: ""),
            ChatTableModel(title: "ㅁㅇㄴㅇㄴㅁㅁㅇㄴㅁㄴㅇ", userId: "")
        ])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setComponents()
        setComponentsValue()
        setConstraints()
        bind()
        bindChatTableView()
        viewDidLoadEvent.accept(())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisapperEvent.accept(())
    }
    
    private func setComponents() {
        [tableView, textField,sendButton].forEach {
            view.addSubview($0)
        }
        registerTableView()
    }
    
    private func registerTableView() {
        tableView.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.identifider)
        tableView.register(UserChatTableViewCell.self, forCellReuseIdentifier: UserChatTableViewCell.identifider)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        sendButton.setImage(SLPAssets.CustomImage.sendMessageButton.image, for: .normal)
        textField.backgroundColor =  SLPAssets.CustomColor.gray1.color
        textField.placeholder = "메세지를 입력하세요"
        textField.layer.cornerRadius = 8
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = false
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        ellipsisButton = UIBarButtonItem(image: SLPAssets.CustomImage.ellipsis.image, style: .plain, target: navigationController, action: nil)
        ellipsisButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = ellipsisButton
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(textField.snp.top).offset(-16)
        }
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(52)
        }
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    private func bind() {
        output.popVC
            .emit(onNext: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.reloadTableView
            .emit(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.enableSendButton
            .emit(onNext: { [weak self] check in
                check ? self?.sendButton.setImage(SLPAssets.CustomImage.sendMessageButtonFilled.image, for: .normal) : self?.sendButton.setImage(SLPAssets.CustomImage.sendMessageButton.image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.addMyChat
            .emit(onNext: { [weak self] data in
                var array = self?.chattingSection.value
                array?[0].items.append(data)
                guard let array = array else { return }
                self?.chattingSection.accept(array)
            })
            .disposed(by: disposeBag)
        
        output.addUserChat
            .emit(onNext: { [weak self] data in
                var array = self?.chattingSection.value
                array?[0].items.append(data)
                guard let array = array else { return }
                self?.chattingSection.accept(array)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindChatTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<ChatTableSectionModel> { [weak self] data, tableView, indexPath, item in
            tableView.separatorStyle = .none
            
            if self?.chattingSection.value[0].items[indexPath.item].userId  == UserDefaults.userId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.identifider, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell() }
               cell.selectionStyle = .none
               cell.configure(indexPath: indexPath, item: item)
                DispatchQueue.main.async {
                    let indexPath:IndexPath = IndexPath(row: (self?.chattingSection.value[0].items.count ?? 0) - 1, section: 0)
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
               return cell
           } else {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: UserChatTableViewCell.identifider, for: indexPath) as? UserChatTableViewCell else { return UITableViewCell() }
               cell.selectionStyle = .none
               cell.configure(indexPath: indexPath, item: item)
               DispatchQueue.main.async {
                   let indexPath:IndexPath = IndexPath(row: (self?.chattingSection.value[0].items.count ?? 0) - 1, section: 0)
                   tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
               }
               return cell
           }
        }
        chattingSection
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ChatViewController: UITextViewDelegate { }
