//
//  SearchCollectionViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/23.
//

import UIKit

import SnapKit

final class SearchCollectionViewCell: UICollectionViewCell {
    
    static var identifider: String {
        return "SearchCollectionViewCell"
    }
    
    private var searchButton = UIButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        contentView.addSubview(searchButton)
    }
    
    func setConstraints() {
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(2)
            make.width.height.equalTo(50)
        }
    }
    
    func configure(indexPath: IndexPath, item: SearchCollecionSectionModel.Item) {
        searchButton.setTitle(item.title, for: .normal)
    }
}
