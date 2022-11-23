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
        searchButton.titleLabel?.textAlignment = .center
        searchButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        searchButton.sizeToFit()
    }
    
    func setConstraints() {
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(32)
            
        }
    }
    
    func configure(indexPath: IndexPath, item: SearchCollecionSectionModel.Item) {
        searchButton.setTitle(item.title, for: .normal)
        searchButton.layer.borderColor = SLPAssets.CustomColor.gray4.color.cgColor
        searchButton.layer.borderWidth = 1
        searchButton.layer.cornerRadius = 8
        searchButton.setTitleColor(SLPAssets.CustomColor.black.color, for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 14)
    }
}
