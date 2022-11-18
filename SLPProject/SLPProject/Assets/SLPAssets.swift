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
        case boyButton
        case girlButton
        case backButton
        case splashImage
        case splashTextImage
        case homeIcon
        case shopIcon
        case friendIcon
        case infoIcon
        case rightButton
        case myInfoProfile
        case searchButton
        case matchingButton
        case messageButton
        case gpsButton
        case mapMarker
        
        var image: UIImage {
            switch self {
            case .firstOnboardingImage:
                return UIImage(named: "FirstOnboardingImage")!
                
            case .secondOnboardingImage:
                return UIImage(named: "SecondOnboardingImage")!
                
            case .thirdOnboardingImage:
                return UIImage(named: "ThirdOnboardingImage")!
                
            case .boyButton:
                return UIImage(named: "boyButton")!
                
            case .girlButton:
                return UIImage(named: "girlButton")!
                
            case .backButton:
                return UIImage(systemName: "arrow.backward")!
                
            case .splashImage:
                return UIImage(named: "splashLogo")!
                
            case .splashTextImage:
                return UIImage(named: "splashText")!
                
            case .homeIcon:
                return UIImage(named: "homeIcon")!
                
            case .shopIcon:
                return UIImage(named: "shopIcon")!
                
            case .friendIcon:
                return UIImage(named: "friendIcon")!
                
            case .infoIcon:
                return UIImage(named: "infoIcon")!
                
            case .rightButton:
                return UIImage(systemName: "chevron.right")!
                
            case .myInfoProfile:
                return UIImage(named: "myInfoProfile")!
                
            case .searchButton:
                return UIImage(named: "searchButton")!
                
            case .matchingButton:
                return UIImage(named: "matchingButton")!
                
            case .messageButton:
                return UIImage(named: "messageButton")!
                
            case .gpsButton:
                return UIImage(named: "gpsButton")!
                
            case .mapMarker:
                return UIImage(named: "mapMarker")!
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
                return UIColor().hexStringToUIColor(hex: "#333333")
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
        case enterNickName
        case writeTenLetters
        case writeNickNameLetters
        case enterBirth
        case ageLimit
        case writeAllCases
        case enterEmail
        case emailSubtext
        case emailPlaceholder
        case wrongEmailType
        case selectGender
        case boy
        case girl
        case genderRequired
        case next
        case checkNetwork
        case invalidateNickname
        case confirm
        case profileImageString
        case noticeImageString
        case qnaImageString
        case alarmImageString
        case permitImageString
        case faqImageString
        case notice
        case qna
        case alaram
        case permit
        case faq
        case matchingButtonString
        
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
                
            case .enterNickName:
                return "닉네임을 입력해 주세요"
                
            case .writeTenLetters:
                return "10자 이내로 입력"
                
            case .ageLimit:
                return "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
                
            case .next:
                return "다음"
                
            case .writeNickNameLetters:
                return "닉네임은 1자 이상 10자 이내로 부탁드려요."
                
            case .writeAllCases:
                return "나이 정보를 모두 입력해주세요"
                
            case .enterEmail:
                return "이메일을 입력해주세요"
                
            case .emailSubtext:
                return "휴대폰 변경 시 인증을 위해 사용해요"
                
            case .emailPlaceholder:
                return "SeSAC@email.com"
                
            case .enterBirth:
                return "생년월일을 알려주세요"
                
            case .wrongEmailType:
                return "메일 형식이 올바르지 않습니다."
                
            case .selectGender:
                return "성별을 선택해 주세요"
                
            case .genderRequired:
                return "새싹 찾기 기능을 이용하기 위해서 필요해요!"
                
            case .boy:
                return "남자"
                
            case .girl:
                return "여자"
                
            case .checkNetwork:
                return "네트워크 연결 상태를 확인해주세요"
                
            case .invalidateNickname:
                return "부적합한 닉네임입니다."
                
            case .confirm:
                return "확인"
                
            case .profileImageString:
                return "profile"
                
            case .noticeImageString:
                return "notice"
                
            case .qnaImageString:
                return "qna"
                
            case .alarmImageString:
                return "setting_alarm"
                
            case .permitImageString:
                return "permit"
                
            case .faqImageString:
                return "faq"
                
            case .notice:
                return "공지사항"
                
            case .qna:
                return "1:1 문의"
                
            case .alaram:
                return "알림 설정"
                
            case .permit:
                return "이용약관"
                
            case .faq:
                return "자주 묻는 질문"
                
            case .matchingButtonString:
                return "matchingButton"
            }
        }
    }
}
