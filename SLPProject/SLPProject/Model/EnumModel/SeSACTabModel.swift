//
//  SeSACTabModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/26.
//

import Foundation

enum SeSACTabModel: String {
    
    case near
    case receive
    
    var emptyViewMain: String {
        switch self {
        case .near:
            return "아쉽게도 주변에 새싹이 없어요"
        case .receive:
            return "아직 받은 요청이 없어요"
        }
    }
    
    var emptyViewSub: String {
        switch self {
        case .near:
            return "스터디를 변경하거나 조금만 더 기다려 주세요"
        case .receive:
            return "스터디를 변경하거나 조금만 더 기다려 주세요"
        }
    }
    
    var alertTitle: String {
        switch self {
        case .near:
            return "스터디를 요청할게요!"
        case .receive:
            return "스터디를 수락할까요?"
        }
    }
    
    var alertContents: String {
        switch self {
        case .near:
            return "상대방이 요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        case .receive:
            return "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요"
        }
    }
}
