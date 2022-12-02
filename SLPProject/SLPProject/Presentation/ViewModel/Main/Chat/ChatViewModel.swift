//
//  ChatViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import Foundation

import RxCocoa
import RxSwift

final class ChatViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let sendButtonTapped: Signal<String>
        let textFieldValue: Signal<String>
        let viewDidDisapper: Observable<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let reloadTableView: Signal<Void>
        let enableSendButton: Signal<Bool>
    }
    
    private var chat: ChatMessageModel = ChatMessageModel(chat: "")
    private let enableSendButtonRelay = PublishRelay<Bool>()
    private let popVCRelay = PublishRelay<Void>()
    private let reloadTableViewRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                SocketIOManager.shared.establishConnection()
                self?.setObserver()
            })
            .disposed(by: disposeBag)
        
        input.textFieldValue
            .emit { [weak self] text in
                text.count != 0 ? self?.enableSendButtonRelay.accept(true) : self?.enableSendButtonRelay.accept(false)
            }
            .disposed(by: disposeBag)
        
        input.sendButtonTapped
            .emit { [weak self] chatMessage in
                self?.chat = ChatMessageModel(chat: chatMessage)
                self?.sendChatMessage()
            }
            .disposed(by: disposeBag)
        
        input.backButtonTapped
            .emit { [weak self] _ in
                self?.popVCRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input.viewDidDisapper
            .subscribe(onNext: {
                SocketIOManager.shared.closeConnection()
            })
            .disposed(by: disposeBag)
        
        return Output(
            popVC: popVCRelay.asSignal(),
            reloadTableView: reloadTableViewRelay.asSignal(),
            enableSendButton: enableSendButtonRelay.asSignal()
        )
    }
}

extension ChatViewModel {
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification: )), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    @objc private func getMessage(notification: NSNotification) {
     
    }
    
    private func sendChatMessage() {
        APIService().sendChatMessage(dictionary: chat.toDictionary, id: UserDefaults.matchedUID) { result in
            switch result {
            case .success(_):
                print("success")
                
            case .failure(let error):
                let error = ChatMessagErroreModel(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
                case .sendChatFailure:
                    print(ChatMessagErroreModel.sendChatFailure)
                case .tokenError:
                    print(ChatMessagErroreModel.tokenError)
                case .unregistered:
                    print(ChatMessagErroreModel.unregistered)
                case .serverError:
                    print(ChatMessagErroreModel.serverError)
                case .clientError:
                    print(ChatMessagErroreModel.clientError)
                case .unknown:
                    print(ChatMessagErroreModel.unknown)
                }
            }
        }
    }
}
