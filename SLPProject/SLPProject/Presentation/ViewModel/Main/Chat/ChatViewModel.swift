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
        let addUserChat: Signal<ChatTableModel>
        let addMyChat: Signal<ChatTableModel>
    }
    
    private let manager = SocketIOManager()
    private var lastChatDate: String = ""
    
    private var chat: ChatMessageModel = ChatMessageModel(chat: "")
    private let enableSendButtonRelay = PublishRelay<Bool>()
    private let popVCRelay = PublishRelay<Void>()
    private let reloadTableViewRelay = PublishRelay<Void>()
    private let addUserChatRelay = PublishRelay<ChatTableModel>()
    private let addMyChatRelay = PublishRelay<ChatTableModel>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.manager.establishConnection()
                self?.getChatMessage()
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
            .subscribe(onNext: { [weak self] _ in
                self?.manager.closeConnection()
            })
            .disposed(by: disposeBag)
        
        manager.getDataRelay.asSignal()
            .emit(onNext: { [weak self] data in
                self?.chat = ChatMessageModel(chat: data.chat)
                self?.addUserChatRelay.accept(ChatTableModel(title: self?.chat.chat ?? "", userId: data.id))
                self?.lastChatDate = data.createdAt
            })
            .disposed(by: disposeBag)
        
        return Output(
            popVC: popVCRelay.asSignal(),
            reloadTableView: reloadTableViewRelay.asSignal(),
            enableSendButton: enableSendButtonRelay.asSignal(),
            addUserChat: addUserChatRelay.asSignal(),
            addMyChat: addMyChatRelay.asSignal()
        )
    }
}

extension ChatViewModel {
    
    private func sendChatMessage() {
        APIService().sendChatMessage(dictionary: chat.toDictionary, id: UserDefaults.matchedUID) { [weak self] result in
            switch result {
            case .success(_):
                self?.addMyChatRelay.accept(ChatTableModel(title: self?.chat.chat ?? "", userId: UserDefaults.userId))
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
    
    private func getChatMessage() {
        if lastChatDate.isEmpty  {
            lastChatDate = "2000-01-01T06:55:54.784Z"
        }
        print(lastChatDate)
        APIService().getChatMessage(id: UserDefaults.matchedUID, date: lastChatDate) { [weak self] result in
            switch result {
            case .success(let response):
                print("success")
                guard let data = try? JSONDecoder().decode(GetChatMessageModel.self, from: response.data) else { return }
                for index in 0..<data.payload.count {
                    if data.payload[index].id == UserDefaults.matchedUID {
                        self?.addUserChatRelay.accept(ChatTableModel(title: data.payload[index].chat, userId: data.payload[index].id))
                    } else {
                        self?.addMyChatRelay.accept(ChatTableModel(title: data.payload[index].chat, userId: UserDefaults.userId))
                    }
                }
                
            case .failure(let error):
                let error = GetChatMessageError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                switch error {
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
