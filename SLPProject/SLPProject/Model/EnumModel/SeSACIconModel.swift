//
//  SeSACIconModel.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/03.
//

import Foundation

enum SeSACIconModel: String {
    
    case first
    case second
    case third
    case fourth
    case fifth
    
    var iconImageString: String {
        switch self {
        case .first:
            return "sesac_face_1"
        case .second:
            return "sesac_face_2"
        case .third:
            return "sesac_face_3"
        case .fourth:
            return "sesac_face_4"
        case .fifth:
            return "sesac_face_5"
        }
    }
    
    var titleText: String {
        switch self {
        case .first:
            return "기본 새싹"
        case .second:
            return "튼튼 새싹"
        case .third:
            return "민트 새싹"
        case .fourth:
            return "퍼플 새싹"
        case .fifth:
            return "골드 새싹"
        }
    }
    
    var descriptionText: String {
        switch self {
        case .first:
            return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        case .second:
            return "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다."
        case .third:
            return "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다."
        case .fourth:
            return "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다."
        case .fifth:
            return "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
        }
    }
}
