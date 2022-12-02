//
//  ShopTableViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/03.
//

import UIKit

final class ShopTableViewCell: UITableViewCell {
    
    let label = UILabel()
    
    static var identifider: String {
        return "ShopTableViewCell"
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
        label.backgroundColor = SLPAssets.CustomColor.yellowGreen.color
        label.textColor = .black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
    }
    
    private func setConstraints() {
        label.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.lessThanOrEqualToSuperview().offset(-100)
            make.height.equalTo(50)
        }
    }
    
    func configure(indexPath: IndexPath, item: ChatTableSectionModel.Item) {
        label.text = item.title
    }
}
