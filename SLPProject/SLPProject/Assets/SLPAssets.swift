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
        
        var image: UIImage {
            switch self {
            case .firstOnboardingImage:
                return UIImage(named: "FirstOnboardingImage")!
                
            case .secondOnboardingImage:
                return UIImage(named: "SecondOnboardingImage")!
                
            case .thirdOnboardingImage:
                return UIImage(named: "ThirdOnboardingImage")!
            }
        }
    }
    
    enum CustomColor {
        case green
        
        var color: UIColor {
            switch self {
            case .green:
                return UIColor().hexStringToUIColor(hex: "#49DC92")
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
            }
        }
    }
}
