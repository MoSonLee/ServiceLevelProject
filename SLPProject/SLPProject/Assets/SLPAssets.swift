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
        case white
        case black
        case green
        case whiteGreen
        case yellowGreen
        case gray7
        case gray6
        case gray5
        case gray4
        case gray3
        case gray2
        case gray1
        case success
        case error
        case focus
        
        var color: UIColor {
            switch self {
            case .white:
                return UIColor().hexStringToUIColor(hex: "#FFFFFF")
            case .black:
                return UIColor().hexStringToUIColor(hex: "#33333")
            case .green:
                return UIColor().hexStringToUIColor(hex: "#49DC92")
            case .whiteGreen:
                return UIColor().hexStringToUIColor(hex: "#CDF4E1")
            case .yellowGreen:
                return UIColor().hexStringToUIColor(hex: "#B2EB61")
            case .gray7:
                return UIColor().hexStringToUIColor(hex: "#888888")
            case .gray6:
                return UIColor().hexStringToUIColor(hex: "#AAAAAA")
            case .gray5:
                return UIColor().hexStringToUIColor(hex: "#BDBDBD")
            case .gray4:
                return UIColor().hexStringToUIColor(hex: "#D1D1D1")
            case .gray3:
                return UIColor().hexStringToUIColor(hex: "#E2E2E2")
            case .gray2:
                return UIColor().hexStringToUIColor(hex: "#EFEFEF")
            case .gray1:
                return UIColor().hexStringToUIColor(hex: "#F7F7F7")
            case .success:
                return UIColor().hexStringToUIColor(hex: "#628FE6")
            case .error:
                return UIColor().hexStringToUIColor(hex: "#E9666B")
            case .focus:
                return UIColor().hexStringToUIColor(hex: "#333333")
            }
        }
        
        enum Font {
            
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
        case notFormattedNumber
        case tooMuchRequest
        case etcError
        case certifciationfailure
        
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
                
            case .notFormattedNumber:
                return "잘못된 전화번호 형식입니다."
                
            case .tooMuchRequest:
                return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
                
            case .etcError:
                return "에러가 발생했습니다. 다시 시도해주세요"
                
            case .certifciationfailure:
                return "전화 번호 인증 실패"
            }
        }
    }
}
