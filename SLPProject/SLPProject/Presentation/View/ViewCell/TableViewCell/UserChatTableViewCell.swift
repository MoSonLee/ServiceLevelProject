//
//  UserChatTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import UIKit

final class UserChatTableViewCell: UITableViewCell {
    
    let label = UILabel()
    
    static var identifider: String {
        return "UserChatTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setComponents() {
        contentView.addSubview(label)
        label.backgroundColor = SLPAssets.CustomColor.gray4.color
        label.textColor = .black
        label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.black.cgColor
    }
    
    private func setConstraints() {
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-100)
            make.height.equalTo(50)
        }
    }
    
    func configure(indexPath: IndexPath, item: ChatTableSectionModel.Item) {
        label.text = item.title
    }
}
