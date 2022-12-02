//
//  SocketService.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import Foundation

import SocketIO

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    var manager: SocketManager!
    var socket: SocketIOClient!
    var url = URL(string: "\(APIURL.url)/chat/\(UserDefaults.matchedUID)")

    private init() {
        guard let url = url else { return }
        manager = SocketManager(socketURL: url, config: [
            .forceWebsockets(true)
        ])
        
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
