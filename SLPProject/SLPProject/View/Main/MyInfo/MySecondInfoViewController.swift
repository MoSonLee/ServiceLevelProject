//
//  MySecondInfoViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxDataSources
import RxRelay
import SnapKit

final class MySecondInfoViewController: UIViewController {
    
    private let profileImage = UIImageView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setNavigationItems() {
        
    }
    
    private func setComponents() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        profileImage.image = SLPAssets.CustomImage.myInfoProfile.image
        profileImage.contentMode = .scaleAspectFit
        tableView.backgroundColor = .black
    }
    
    private func setComponentsValue() {
        
    }
    
    private func setConstraints() {
        [profileImage, tableView].forEach {
            view.addSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(194)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(profileImage.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
}
