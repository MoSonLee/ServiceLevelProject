//
//  SocketService.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

import RxCocoa
import RxSwift
import SocketIO

final class SocketIOManager {
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    var url = URL(string: "http://api.sesac.co.kr:1210")
    let getDataRelay = PublishRelay<ChatResultModel>()

     init() {
        guard let url = url else { return }
        manager = SocketManager(socketURL: url, config: [ .forceWebsockets(true)])
        socket = manager.defaultSocket
         
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", "kasYmSROz4aMhpmDvnbxiqOtnOF3")
            
        }
         
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
         
         socket.on("chat") { [weak self] dataArray, ack in
             print("보낸 사람 채팅: ", dataArray, ack)
             let data = dataArray[0] as! NSDictionary
             let chat = data["chat"] as! String
             let to = data["to"] as! String
             let from = data["from"] as! String
             let id = data["_id"] as! String
             let createdAt = data["createdAt"] as! String
             self?.getDataRelay.accept(ChatResultModel(id: id, to: to, from: from, chat: chat, createdAt: createdAt))
         }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
