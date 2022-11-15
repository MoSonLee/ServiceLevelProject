//
//  MyInfoTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import SnapKit

final class MyInfoTableViewCell: UITableViewCell {
    
    let button = UIButton()
    let label = UILabel()
    let nextButton = UIButton()
    
    static var identifider: String {
        return "MyInfoTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setComponents() {
        [button, label, nextButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setHeaderConstraints() {
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(2)
            make.right.equalTo(label.snp.left).offset(-13)
            make.width.height.equalTo(50)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(nextButton.snp.left).offset(220.5)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-7.5)
            make.width.equalTo(9)
            make.height.equalTo(18)
        }
    }
    
    func setConstraints() {
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalTo(label.snp.left).offset(-12)
            make.width.height.equalTo(24)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(26)
        }
    }
    
    func configure(indexPath: IndexPath, item: MyInfoTableSectionModel.Item) {
        indexPath.section == 0 ? setHeaderConstraints() : setConstraints()
        button.setImage(UIImage(named: item.buttonImageString), for: .normal)
        label.text = item.title
        nextButton.setImage(SLPAssets.CustomImage.rightButton.image, for: .normal)
        nextButton.tintColor = SLPAssets.CustomColor.gray7.color
    }
}
