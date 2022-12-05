//
//  ChatViewModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/30.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class ChatViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTapped: Signal<Void>
        let sendButtonTapped: Signal<String>
        let textFieldValue: Signal<String>
        let viewDidDisapper: Observable<Void>
        let dodgeButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let reloadTableView: Signal<Void>
        let enableSendButton: Signal<Bool>
        let addUserChat: Signal<ChatTableModel>
        let addMyChat: Signal<ChatTableModel>
    }
    
    private var chatDB: Results<Chat>!
    private var matchedId = ""
    private var matchedNick = ""
    private var lastChatDate: String = ""
    private var dodgeStudyModel = StudyRequestModel(otheruid: "")
    private var chat: ChatMessageModel = ChatMessageModel(chat: "")
    
    private let manager = SocketIOManager()
    private let respositoy = RealmRepository()
    private let enableSendButtonRelay = PublishRelay<Bool>()
    private let popVCRelay = PublishRelay<Void>()
    private let reloadTableViewRelay = PublishRelay<Void>()
    private let addUserChatRelay = PublishRelay<ChatTableModel>()
    private let addMyChatRelay = PublishRelay<ChatTableModel>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.fetchRealm()
                self?.checkMyQueueState()
                self?.manager.establishConnection()
            })
            .disposed(by: disposeBag)
        
        input.dodgeButtonTapped
            .emit { [weak self] _ in
                self?.dodgeStudy()
            }
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
    
    private func fetchRealm() {
        chatDB = respositoy.fetch(id: matchedId)
        print(chatDB)
    }
    
    private func getLastChatDate() {
        //        guard let lastDate = chatDB.last?.chatDate else { return }
        //        lastChatDate = lastDate
        if lastChatDate.isEmpty  {
            lastChatDate = "2000-12-04T09:37:29.029+0900"
        }
    }
    
    private func checkMyQueueState() {
        APIService().checkMyQueueState { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = try? JSONDecoder().decode(MyQueueStateModel.self, from: response.data) else { return }
                
                if data.matched == 1 {
                    self?.matchedId = data.matchedUid
                    self?.matchedNick = data.matchedNick
                    self?.getChatMessage()
                    print(UserDefaults.userToken)
                } else if data.matched == 0 {
                    UserDefaults.homeTabMode = .matching
                    self?.popVCRelay.accept(())
                }
                
            case .failure(let error):
                let error = QueueStateError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                switch error {
                case .notRequestYet:
                    print(QueueStateError.notRequestYet)
                    
                case .tokenError:
                    print(QueueStateError.tokenError)
                    
                case .unregisteredError:
                    print(QueueStateError.unregisteredError)
                    
                case .serverError:
                    print(QueueStateError.serverError)
                    
                case .clientError:
                    print(QueueStateError.clientError)
                    
                case .unknown:
                    print(QueueStateError.unknown)
                }
            }
        }
    }
    
    private func sendChatMessage() {
        print(UserDefaults.homeTabMode)
        print(UserDefaults.matchedUID)
        print(UserDefaults.userToken)
        APIService().sendChatMessage(dictionary: chat.toDictionary, id: matchedId) { [weak self] result in
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
        //        getLastChatDate()
        APIService().getChatMessage(id: matchedId, date: "2000-12-04T09:37:29.029+0900") { [weak self] result in
            switch result {
            case .success(let response):
                print("success")
                print(UserDefaults.userToken)
                guard let data = try? JSONDecoder().decode(GetChatMessageModel.self, from: response.data) else { return }
                for index in 0..<data.payload.count {
                    if data.payload[index].from == self?.matchedId {
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
    
    private func dodgeStudy() {
        dodgeStudyModel = StudyRequestModel(otheruid: matchedId)
        APIService().dodgeStudy(dictionary: dodgeStudyModel.toDictionary) { [weak self] result in
            switch result {
            case .success(_):
                UserDefaults.homeTabMode = .search
                self?.popVCRelay.accept(())
                
            case .failure(let error):
                let error = DodgeError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                switch error {
                case .wrongUID:
                    print(DodgeError.wrongUID)
                    
                case .tokenError:
                    print(DodgeError.tokenError)
                    
                case .serverError:
                    print(DodgeError.serverError)
                    
                case .clientError:
                    print(DodgeError.clientError)
                    
                case .unregistered:
                    print(DodgeError.unregistered)
                    
                case .unknown:
                    print(DodgeError.unknown)
                    
                }
            }
        }
    }
}
