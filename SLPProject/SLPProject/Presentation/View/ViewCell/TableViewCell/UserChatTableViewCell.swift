//
//  UserChatTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import UIKit

final class UserChatTableViewCell: UITableViewCell {
    
    private let textView = UITextView()
    
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
        contentView.addSubview(textView)
        textView.backgroundColor = SLPAssets.CustomColor.white.color
        textView.textColor = .black
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = SLPAssets.CustomColor.gray4.color.cgColor
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.font = .systemFont(ofSize: 15)
    }
    
    private func setConstraints() {
        textView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func configure(indexPath: IndexPath, item: ChatTableSectionModel.Item) {
        textView.text = item.title
    }
}
