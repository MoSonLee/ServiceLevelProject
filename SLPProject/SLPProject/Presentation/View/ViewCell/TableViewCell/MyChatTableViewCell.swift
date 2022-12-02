//
//  MyChatTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/02.
//

import UIKit

final class MyChatTableViewCell: UITableViewCell {
    
    let label = UILabel()
    
    static var identifider: String {
        return "MyChatTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setComponents() {
        contentView.addSubview(label)
    }
    
    func setConstraints() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(26)
        }
    }
    
//    func configure(indexPath: IndexPath, item: ChatTableSectionModel.Item) {
//
//    }
}
