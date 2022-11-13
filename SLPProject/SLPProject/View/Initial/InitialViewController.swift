//
//  InitialViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/13.
//

import UIKit

import SnapKit

final class InitialViewController: UIViewController {
    
    private let splashImage = UIImageView()
    private let splashTextImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
        bind()
    }
    
    private func setComponents() {
        view.backgroundColor = .white
        [splashImage, splashTextImage].forEach {
            view.addSubview($0)
            $0.contentMode = .scaleAspectFit
        }
        setComponentsValue()
    }
    
    private func setComponentsValue() {
        splashImage.image = SLPAssets.CustomImage.splashImage.image
        splashTextImage.image = SLPAssets.CustomImage.splashTextImage.image
    }
    
    private func setConstraints() {
        splashImage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(76)
            make.height.equalTo(264)
            make.bottom.equalTo(splashTextImage.snp.top).inset(-35.44)
        }
        splashTextImage.snp.makeConstraints { make in
            make.top.equalTo(splashImage.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(41)
            make.height.equalTo(101)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(197)
        }
    }
    
    private func bind() {
        
    }
}
