//
//  SLPAssets.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import UIKit

enum SLPAssets {
    
    enum CustomImage {
        case firstOnboardingImage
        case secondOnboardingImage
        case thirdOnboardingImage
        case backButton
        
        var image: UIImage {
            switch self {
            case .firstOnboardingImage:
                return UIImage(named: "FirstOnboardingImage")!
                
            case .secondOnboardingImage:
                return UIImage(named: "SecondOnboardingImage")!
                
            case .thirdOnboardingImage:
                return UIImage(named: "ThirdOnboardingImage")!
                
            case .backButton:
                return UIImage(systemName: "arrow.backward")!
            }
        }
    }
    
    enum CustomColor {
        case green
        case disabledGrey
        case grey3
        case focus
        
        var color: UIColor {
            switch self {
            case .green:
                return UIColor().hexStringToUIColor(hex: "#49DC92")
                
            case .disabledGrey:
                return UIColor().hexStringToUIColor(hex: "#AAAAAA")
                
            case .grey3:
                return UIColor().hexStringToUIColor(hex: "#E2E2E2")
                
            case .focus:
                return UIColor().hexStringToUIColor(hex: "#333333")
            }
        }
    }
    
    enum RawString {
        case stratButtonTitle
        case firstOnboardingTextHeader
        case firstOnboardingTextTail
        case secondOnboardingTextHeader
        case secondOnboardingTextTail
        case thirdOnboardingText
        case loginInitialText
        case loginSecondaryText
        case getCertificationMessage
        case getCertificationMessageSecondary
        case certificationPlaceholderText
        case resendText
        case wrtieCertificationCode
        
        var text: String {
            switch self {
            case .stratButtonTitle:
                return "시작하기"
                
            case .firstOnboardingTextHeader:
                return "위치 기반"
                
            case .firstOnboardingTextTail:
                return "으로 빠르게 주위 친구를 확인"
                
            case .secondOnboardingTextHeader:
                return "스터디를 원하는 친구"
                
            case .secondOnboardingTextTail:
                return "를 찾을 수 있어요"
                
            case .thirdOnboardingText:
                return "SeSAC Study"
                
            case .loginInitialText:
                return "새싹 서비스 이용을 위해 휴대폰 번호를 입력해 주세요"
                
            case .loginSecondaryText:
                return "인증번호가 문자로 전송되었어요"
                
            case .getCertificationMessage:
                return "인증 문자 받기"
                
            case .getCertificationMessageSecondary:
                return "인증하고 시작하기"
                
            case .certificationPlaceholderText:
                return "휴대폰 번호(-없이 숫자만 입력)"
                
            case .resendText:
                return "재전송"
                
            case .wrtieCertificationCode:
                return "인증번호 입력"
            }
        }
    }
}
