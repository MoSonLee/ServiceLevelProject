//
//  FirstOnBoardingViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import UIKit

import SnapKit

final class FirstOnBoardingViewController: UIViewController {
    
    private let textLabel = UILabel()
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        [textLabel, imageView].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
    }
    
    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.leading.equalTo(85)
            make.trailing.equalTo(-85)
            make.height.equalTo(76)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).inset(-56)
            make.centerX.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(8)
        }
    }
    
    private func setComponentsValue() {
        let headerText = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : SLPAssets.CustomColor.green.color]
        let tailText = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24), NSAttributedString.Key.foregroundColor : UIColor.black]
        let header = NSMutableAttributedString(string: SLPAssets.RawString.firstOnboardingTextHeader.text , attributes:headerText)
        let tail = NSMutableAttributedString(string: SLPAssets.RawString.firstOnboardingTextTail.text, attributes: tailText)
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        header.append(tail)
        textLabel.attributedText = header
        
        imageView.image = SLPAssets.CustomImage.firstOnboardingImage.image
    }
}
