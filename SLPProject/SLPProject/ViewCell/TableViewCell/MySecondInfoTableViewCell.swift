//
//  MySecondInfoTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import DoubleSlider

class MySecondInfoTableViewCell: UITableViewCell {
    
    private let profileNameLabel = UILabel()
    private let showInfoButton = UIButton()
    private let leftLabel = UILabel()
    private let boyButton = UIButton()
    private let girlButton = UIButton()
    private let textField = UITextField()
    private let switchButton = UISwitch()
    private let ageLabel = UILabel()
    private let doubleSlider = DoubleSlider()
    private let withdrawButton = UIButton()
    
    static var identifider: String {
        return "MySecondInfoTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setComponents() {
        [profileNameLabel, showInfoButton, leftLabel, boyButton, girlButton, textField, switchButton, ageLabel, doubleSlider, withdrawButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setFirstCell() {
        profileNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(26)
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(showInfoButton.snp.left).offset(-10)
        }
        showInfoButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(26)
            make.right.equalToSuperview().offset(-26)
            make.width.equalTo(6)
            make.height.equalTo(12)
        }
    }
    
    func setLeftLabel() {
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(97)
            make.centerY.equalToSuperview()
        }
    }
    
    func setSecondCell() {
       setLeftLabel()
        boyButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(girlButton.snp.left).offset(-8)
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
        girlButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(48)
        }
    }
    
    func setThirdCell() {
        setLeftLabel()
        textField.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(164)
        }
    }
    
    func setFourthCell() {
        setLeftLabel()
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(28)
        }
    }
    
    func setFifthCell() {
        setLeftLabel()
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(22)
        }
    }
    
    func setSixCell() {
        doubleSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    func setSeventhCell() {
        setLeftLabel()
    }
}
