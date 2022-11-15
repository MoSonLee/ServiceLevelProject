//
//  MySecondInfoTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import DoubleSlider

final class MySecondInfoTableViewCell: UITableViewCell {
    
    private let backView = UIView()
    let showInfoButton = UIButton()
    private let leftLabel = UILabel()
    private let boyButton = UIButton()
    private let girlButton = UIButton()
    private let textField = UITextField()
    private let switchButton = UISwitch()
    private let ageLabel = UILabel()
    private let doubleSlider = DoubleSlider()
    private let withdrawButton = UIButton()
    
    private let titleLabel = UILabel()
    private let reviewLabel = UILabel()
    private let waitingLabel = UILabel()
    
    private let mannerButton = UIButton()
    private let timeButton = UIButton()
    private let responseButton = UIButton()
    private let kindButton = UIButton()
    private let niceSkillButton = UIButton()
    private let niceTimeButton = UIButton()
    
    static var identifider: String {
        return "MySecondInfoTableViewCell"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFirstCell() {
        contentView.addSubview(backView)
        [leftLabel, showInfoButton].forEach {
            contentView.addSubview($0)
        }
        backView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        leftLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(showInfoButton.snp.left).offset(-10)
        }
        showInfoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-26)
            make.width.equalTo(24)
            make.height.equalTo(12)
        }
        showInfoButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
    }
    
    func setLeftLabel() {
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(150)
            make.centerY.equalToSuperview()
        }
    }
    
    func setSecondCell() {
        [leftLabel, boyButton, girlButton].forEach {
            contentView.addSubview($0)
        }
        setLeftLabel()
        boyButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(girlButton.snp.left).offset(-8)
            make.width.equalTo(56)
            make.height.equalToSuperview()
        }
        girlButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalToSuperview()
        }
    }
    
    func setThirdCell() {
        [leftLabel, textField].forEach {
            contentView.addSubview($0)
        }
        setLeftLabel()
        textField.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(164)
        }
    }
    
    func setFourthCell() {
        [leftLabel, switchButton].forEach {
            contentView.addSubview($0)
        }
        setLeftLabel()
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(28)
            make.right.equalToSuperview()
        }
    }
    
    func setFifthCell() {
        [leftLabel, ageLabel].forEach {
            contentView.addSubview($0)
        }
        setLeftLabel()
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(22)
        }
    }
    
    func setSixCell() {
        contentView.addSubview(doubleSlider)
        doubleSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    func setSeventhCell() {
        contentView.addSubview(leftLabel)
        setLeftLabel()
    }
    
    func setExpandFirstCell() {
        [titleLabel, mannerButton, timeButton, responseButton, kindButton, niceSkillButton, niceTimeButton, waitingLabel, reviewLabel].forEach {
            contentView.addSubview($0)
        }
        
        backView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
            
        }
        
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(showInfoButton.snp.left).offset(-10)
            make.bottom.equalTo(titleLabel.snp.top).offset(24)
        }
        showInfoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-26)
            make.width.equalTo(24)
            make.height.equalTo(12)
            make.bottom.equalTo(titleLabel.snp.top).offset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(18)
            make.bottom.equalTo(mannerButton.snp.top).offset(16)
        }
        
        mannerButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(32)
            make.right.equalTo(timeButton.snp.left).offset(-8)
            make.bottom.equalTo(timeButton.snp.top).offset(16)
        }
        
        timeButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.bottom.equalTo(timeButton.snp.top).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        responseButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(32)
            make.right.equalTo(kindButton.snp.left).offset(-8)
            make.bottom.equalTo(niceSkillButton.snp.top).offset(16)
        }
        
        kindButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(niceSkillButton.snp.top).offset(16)
        }
        
        niceSkillButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(32)
            make.right.equalTo(kindButton.snp.left).offset(-8)
            make.bottom.equalTo(titleLabel.snp.top).offset(-29)
        }
        
        niceTimeButton.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(titleLabel.snp.top).offset(-29)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(47)
            make.height.equalTo(18)
            make.bottom.equalTo(waitingLabel.snp.top).offset(-16)
        }
        
        waitingLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(169)
            make.height.equalTo(24)
            make.bottom.equalToSuperview().offset(-16)
        }
        showInfoButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
    }
    
    func setConstraints(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            setFirstCell()
            leftLabel.font = UIFont.boldSystemFont(ofSize: 16)
            
        case 1:
            leftLabel.font = UIFont.systemFont(ofSize: 14)
            switch indexPath.row {
            case 0:
                setSecondCell()
            case 1:
                setThirdCell()
            case 2:
                setFourthCell()
            case 3:
                setFifthCell()
            case 4:
                setSixCell()
            case 5:
                setSeventhCell()
                
            default:
                print("indexPath Error")
            }
            
        default:
            print("indexPath Error")
        }
    }
    
    func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        selectionStyle = .none
        leftLabel.text = item.title
        showInfoButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        showInfoButton.tintColor = .black
        boyButton.setTitle("남자", for: .normal)
        girlButton.setTitle("여자", for: .normal)
        switchButton.isOn = item.switchType ?? false
        ageLabel.text = item.age
        textField.placeholder = "스터디를 입력해 주세요"
        [boyButton, girlButton].forEach {
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.black, for: .normal)
        }
        doubleSlider.backgroundColor = SLPAssets.CustomColor.gray2.color
        
        backView.backgroundColor = .clear
        backView.layer.borderWidth = 1
        backView.layer.cornerRadius = 8
        backView.layer.borderColor = SLPAssets.CustomColor.gray2.color.cgColor
        
        mannerButton.setTitle("좋은 매너", for: .normal)
        timeButton.setTitle("정확한 시간 약속", for: .normal)
        responseButton.setTitle("빠른 응답", for: .normal)
        kindButton.setTitle("친절한 성격", for: .normal)
        niceSkillButton.setTitle("능숙한 실력", for: .normal)
        niceTimeButton.setTitle("유익한 시간", for: .normal)
        
        [mannerButton, timeButton, responseButton, kindButton, niceSkillButton, niceTimeButton].forEach {
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = SLPAssets.CustomColor.gray2.color.cgColor
            $0.tintColor = SLPAssets.CustomColor.green.color
            $0.backgroundColor = .gray
        }
        
        titleLabel.text = "새싹 타이틀"
        reviewLabel.text = "새싹 리뷰"
        waitingLabel.text = "첫 리뷰를 기다리는 중이에요!"
        reviewLabel.textColor = SLPAssets.CustomColor.black.color
        waitingLabel.textColor = SLPAssets.CustomColor.gray6.color
    }
}
