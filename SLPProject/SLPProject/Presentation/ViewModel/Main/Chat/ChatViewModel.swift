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
        let dodgeButtonTapped: Signal<Void>
    }
    
    struct Output {
        let popVC: Signal<Void>
        let reloadTableView: Signal<Void>
        let enableSendButton: Signal<Bool>
        let addUserChat: Signal<ChatTableModel>
        let addMyChat: Signal<ChatTableModel>
    }
    
    var chattingSection = BehaviorRelay(value: [
        ChatTableSectionModel(header: "", items: [
        ])
    ])
    
    private var chatArray: [Chat] = []
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
                self?.addSectionData()
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
                guard let self = self else { return }
                var array = self.chattingSection.value
                self.addRealm(chat: Chat(chat: self.chat.chat, chatDate: "", id: data.id))
                self.chat = ChatMessageModel(chat: data.chat)
                array[0].items.append(ChatTableModel(title: self.chat.chat, userId: data.id))
                self.chattingSection.accept(array)
                self.addUserChatRelay.accept(ChatTableModel(title: self.chat.chat, userId: data.id))
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
    
    private func addRealm(chat: Chat) {
        respositoy.create(chat: chat)
    }
    
    private func fetchRealm() {
        chatArray = respositoy.fetch(id: UserDefaults.matchedUID, myId: UserDefaults.userId)
        print(chatArray)
    }
    
    private func getLastChatDate() {
        guard let lastDate = chatArray.last?.chatDate else {
            lastChatDate = "2000-12-04T09:37:29.029+0900"
            return
        }
        lastChatDate = lastDate
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
                } else if data.matched == 0 {
                    UserDefaults.homeTabMode = .matching
                    self?.popVCRelay.accept(())
                }
                
            case .failure(let error):
                let error = QueueStateError(rawValue: error.response?.statusCode ?? -1) ?? .unknown
                print(error)
            }
        }
    }
    
    private func sendChatMessage() {
        APIService().sendChatMessage(dictionary: chat.toDictionary, id: matchedId) { [weak self] result in
            switch result {
            case .success(_):
                self?.addRealm(chat: Chat(chat: self?.chat.chat ?? "", chatDate: Date().ISO8601Format(), id: UserDefaults.userId))
                var array = self?.chattingSection.value
                array?[0].items.append(ChatTableModel(title: self?.chat.chat ?? "", userId: UserDefaults.userId))
                guard let array = array else { return }
                self?.chattingSection.accept(array)
                self?.addMyChatRelay.accept(ChatTableModel(title: self?.chat.chat ?? "", userId: UserDefaults.userId))
              
            case .failure(let error):
                let error = ChatMessagErroreModel(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                print(error)
            }
        }
    }
    
    private func getChatMessage() {
        getLastChatDate()
        APIService().getChatMessage(id: matchedId, date: lastChatDate) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = try? JSONDecoder().decode(GetChatMessageModel.self, from: response.data) else { return }
                for index in 0..<data.payload.count {
                    if data.payload[index].from == self?.matchedId {
                        self?.addRealm(chat: Chat(chat: data.payload[index].chat, chatDate: data.payload[index].createdAt, id: data.payload[index].id))
                        var array = self?.chattingSection.value
                        array?[0].items.append(ChatTableModel(title: data.payload[index].chat, userId: data.payload[index].id))
                        guard let array = array else { return }
                        self?.chattingSection.accept(array)
                        self?.addMyChatRelay.accept(ChatTableModel(title: data.payload[index].chat, userId: data.payload[index].id))
                    } else {
                        self?.addRealm(chat: Chat(chat: data.payload[index].chat, chatDate: data.payload[index].createdAt, id: UserDefaults.userId))
                        var array = self?.chattingSection.value
                        array?[0].items.append(ChatTableModel(title: data.payload[index].chat, userId: UserDefaults.userId))
                        guard let array = array else { return }
                        self?.chattingSection.accept(array)
                        self?.addMyChatRelay.accept(ChatTableModel(title: data.payload[index].chat, userId: UserDefaults.userId))
                    }
                }
                
            case .failure(let error):
                let error = GetChatMessageError(rawValue: error.response?.statusCode ?? -1 ) ?? .unknown
                print(error)
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
                print(error)
            }
        }
    }
    
    private func addSectionData() {
        let chats = chatArray.map {
            return ChatTableModel(title: $0.chat, userId: $0.id)
        }
        var array = chattingSection.value
        array[0].items.append(contentsOf: chats)
        chattingSection.accept(array)
    }
}
