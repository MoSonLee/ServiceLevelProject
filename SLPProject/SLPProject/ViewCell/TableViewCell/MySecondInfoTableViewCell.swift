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
        
    }
    
    func setSecondCell() {
        
    }
    
    func setThirdCell() {
        
    }
    
    func setFourthCell() {
        
    }
    
    func setFifthCell() {
        
    }
    
    func setSixCell() {
        
    }
    
    func setSeventhCell() {
        
    }
}
