//
//  MySecondInfoTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import DoubleSlider
import RxCocoa
import RxSwift

class MyPageDetailViewCell: UITableViewCell {
    func setConfigure() {}
    func setConstraints() {}
    func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) { }
}

final class ProfileImageButtonCell: MyPageDetailViewCell {
    
    private let profileImage = UIImageView()
    private let titleLabel = UILabel()
    private let backView = UIView()
    var showInfoButton = UIButton()
    private let lineView = UIView()
    var disposeBag = DisposeBag()
    
    private let sesacLabel = UILabel()
    let mannerButton = UIButton()
    let timeButton = UIButton()
    let responseButton = UIButton()
    let kindButton = UIButton()
    let niceSkillButton = UIButton()
    let niceTimeButton = UIButton()
    let reviewHeader = UILabel()
    let reviewContent = UILabel()
    
    static var identifider: String {
        return "ProfileImageButtonCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        showInfoButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        showInfoButton.tintColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func setConstraints() {
        [profileImage, backView].forEach {
            contentView.addSubview($0)
        }
        
        [titleLabel, showInfoButton, lineView].forEach {
            backView.addSubview($0)
        }
        
        profileImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(194)
        }
        backView.snp.makeConstraints { make in
            make.left.equalTo(profileImage.snp.left)
            make.top.equalTo(profileImage.snp.bottom)
            make.right.equalTo(profileImage.snp.right)
            make.bottom.equalToSuperview().offset(-24).priority(.low)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.lessThanOrEqualTo(showInfoButton.snp.left).offset(-10)
            make.top.equalToSuperview().offset(16)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(0).priority(.low)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.bottom.right.equalToSuperview()
        }
        showInfoButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func setExpand(toggle: Bool) {
        let height = toggle ? 310 : 0
        let image = toggle ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        showInfoButton.setImage(image, for: .normal)
        
        if toggle {
            [sesacLabel,mannerButton, timeButton, responseButton, kindButton, niceSkillButton, niceTimeButton, reviewHeader, reviewContent].forEach {
                lineView.addSubview($0)
            }
            sesacLabel.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(100)
            }
            mannerButton.snp.makeConstraints { make in
                make.top.equalTo(sesacLabel.snp.bottom).offset(16)
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(lineView.snp.width).multipliedBy(0.45)
            }
            timeButton.snp.makeConstraints { make in
                make.top.equalTo(sesacLabel.snp.bottom).offset(16)
                make.right.equalToSuperview().offset(-17)
                make.width.equalTo(lineView).multipliedBy(0.45)
            }
            responseButton.snp.makeConstraints { make in
                make.top.equalTo(timeButton.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(lineView.snp.width).multipliedBy(0.45)
            }
            kindButton.snp.makeConstraints { make in
                make.top.equalTo(timeButton.snp.bottom).offset(8)
                make.right.equalToSuperview().offset(-17)
                make.width.equalTo(lineView).multipliedBy(0.45)
            }
            niceSkillButton.snp.makeConstraints { make in
                make.top.equalTo(kindButton.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(lineView.snp.width).multipliedBy(0.45)
            }
            niceTimeButton.snp.makeConstraints { make in
                make.top.equalTo(kindButton.snp.bottom).offset(8)
                make.right.equalToSuperview().offset(-17)
                make.width.equalTo(lineView).multipliedBy(0.45)
            }
            reviewHeader.snp.makeConstraints { make in
                make.top.equalTo(niceSkillButton.snp.bottom).offset(24)
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(lineView).multipliedBy(0.2)
            }
            reviewContent.snp.makeConstraints { make in
                make.top.equalTo(reviewHeader.snp.bottom).offset(16)
                make.left.equalToSuperview().offset(16)
                make.width.equalTo(lineView).multipliedBy(0.8)
                make.bottom.equalToSuperview().offset(-16)
            }
            lineView.snp.updateConstraints { make in
                make.height.equalTo(height).priority(.low)
            }
        } else {
            [sesacLabel,mannerButton, timeButton, responseButton, kindButton, niceSkillButton, niceTimeButton, reviewHeader, reviewContent].forEach {
                $0.removeFromSuperview()
            }
            lineView.snp.updateConstraints { make in
                make.height.equalTo(height).priority(.low)
            }
        }
        [mannerButton, timeButton, responseButton, kindButton, niceSkillButton, niceTimeButton].forEach {
            $0.backgroundColor = SLPAssets.CustomColor.white.color
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = SLPAssets.CustomColor.gray2.color.cgColor
            $0.layer.cornerRadius = 8
        }
        
        sesacLabel.text = "새싹 타이틀"
        mannerButton.setTitle("좋은 매너", for: .normal)
        timeButton.setTitle("정확한 시간 약속", for: .normal)
        responseButton.setTitle("빠른 응답", for: .normal)
        kindButton.setTitle("친절한 성격", for: .normal)
        niceSkillButton.setTitle("능숙한 실력", for: .normal)
        niceTimeButton.setTitle("유익한 시간", for: .normal)
        reviewHeader.text = "새싹 리뷰"
        reviewContent.text = "첫 리뷰를 기다리는 중이에요!"
        reviewContent.textColor = SLPAssets.CustomColor.gray6.color
    }
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        profileImage.image = SLPAssets.CustomImage.myInfoProfile.image
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 8
        
        titleLabel.text = item.title
        
        backView.backgroundColor = .clear
        backView.layer.borderWidth = 1
        backView.layer.cornerRadius = 8
        backView.layer.borderColor = SLPAssets.CustomColor.gray2.color.cgColor
        
        lineView.backgroundColor = .clear
    }
    
    func configureToNear(indexPath: IndexPath, item: NearSeSACTableSectionModel.Item) {
        
        let buttonArray = [mannerButton, timeButton, responseButton, kindButton, niceSkillButton, niceTimeButton]
        
        profileImage.image = SLPAssets.CustomImage.myInfoProfile.image
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 8
        
        titleLabel.text = item.title
        item.review.forEach {
            reviewContent.text = $0
        }
        
        for i in 0..<item.reputation.count {
            for j in 0..<6 {
                if item.reputation[i] == 1 {
                    buttonArray[j].backgroundColor = SLPAssets.CustomColor.green.color
                    buttonArray[j].setTitleColor(.white, for: .normal)
                }
            }
        }
        
        reviewContent.numberOfLines = 0
        backView.backgroundColor = .clear
        backView.layer.borderWidth = 1
        backView.layer.cornerRadius = 8
        backView.layer.borderColor = SLPAssets.CustomColor.gray2.color.cgColor
        
        lineView.backgroundColor = .clear
    }
    
}

final class GenderCell: MyPageDetailViewCell {
    
    private let titleLabel = UILabel()
    let boyButton = UIButton()
    let girlButton = UIButton()
    var disposeBag = DisposeBag()
    
    static var identifider: String {
        return "GenderCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        [titleLabel, boyButton, girlButton].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(boyButton.snp.left).offset(-181)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
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
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        titleLabel.text = item.title
        boyButton.setTitle("남자", for: .normal)
        girlButton.setTitle("여자", for: .normal)
        [boyButton, girlButton].forEach {
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func girlButtonClicked() {
        if girlButton.currentTitleColor == .black {
            girlButton.backgroundColor = SLPAssets.CustomColor.green.color
            girlButton.setTitleColor(SLPAssets.CustomColor.white.color, for: .normal)
            girlButton.layer.borderWidth = 0
            boyButton.backgroundColor = SLPAssets.CustomColor.white.color
            boyButton.setTitleColor(.black, for: .normal)
            boyButton.layer.borderWidth = 1
        } else {
            girlButton.backgroundColor = SLPAssets.CustomColor.white.color
            girlButton.setTitleColor(.black, for: .normal)
            girlButton.layer.borderWidth = 1
        }
    }
    
    func boyButtonClicked() {
        if boyButton.currentTitleColor == .black {
            boyButton.backgroundColor = SLPAssets.CustomColor.green.color
            boyButton.setTitleColor(SLPAssets.CustomColor.white.color, for: .normal)
            boyButton.layer.borderWidth = 0
            girlButton.backgroundColor = SLPAssets.CustomColor.white.color
            girlButton.setTitleColor(.black, for: .normal)
            girlButton.layer.borderWidth = 1
        } else {
            boyButton.backgroundColor = SLPAssets.CustomColor.white.color
            boyButton.setTitleColor(.black, for: .normal)
            boyButton.layer.borderWidth = 1
        }
    }
}

final class StudyCell: MyPageDetailViewCell {
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    static var identifider: String {
        return "StudyCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        [titleLabel, textField].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(textField.snp.left).offset(-94)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(164)
        }
    }
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        titleLabel.text = item.title
        textField.placeholder = item.study
    }
}

final class NumberCell: MyPageDetailViewCell {
    
    private let titleLabel = UILabel()
    private let switchButton = UISwitch()
    
    static var identifider: String {
        return "NumberCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        [titleLabel, switchButton].forEach {
            contentView.addSubview($0)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(switchButton.snp.left).offset(-191)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        switchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(28)
            make.right.equalToSuperview().offset(-2)
        }
    }
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        titleLabel.text = item.title
        switchButton.isOn = item.switchType ?? false
    }
}

final class AgeCell: MyPageDetailViewCell {
    
    private let titleLabel = UILabel()
    private let ageLabel = UILabel()
    
    static var identifider: String {
        return "AgeCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        [titleLabel, ageLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(ageLabel.snp.left).offset(-218)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(22)
        }
    }
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        titleLabel.text = item.title
        ageLabel.text = item.age
        ageLabel.textColor = SLPAssets.CustomColor.green.color
    }
}

final class DoubleSliderCell: MyPageDetailViewCell {
    
    private let doubleSlider = DoubleSlider()
    
    static var identifider: String {
        return "DoubleSliderCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        contentView.addSubview(doubleSlider)
        doubleSlider.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        doubleSlider.backgroundColor = .green
    }
}

final class WithdrawCell: MyPageDetailViewCell {
    
    let withdrawButton = UIButton()
    var disposeBag = DisposeBag()
    
    static var identifider: String {
        return "WithdrawCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setConstraints() {
        contentView.addSubview(withdrawButton)
        withdrawButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
    }
    
    override func configure(indexPath: IndexPath, item: MySecondInfoTableSectionModel.Item) {
        withdrawButton.setTitle(item.title, for: .normal)
        withdrawButton.setTitleColor(.black, for: .normal)
    }
}
