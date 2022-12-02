//
//  ShopCollectionViewCell.swift
//  SLPProject
//
//  Created by 이승후 on 2022/12/03.
//

import UIKit

import SnapKit

final class ShopCollectionViewCell: UICollectionViewCell {
    
    static var identifider: String {
        return "ShopCollectionViewCell"
    }
    
    var shopImage = UIImageView()
    var sesacLabel = UILabel()
    var sesacDescriptionLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        [shopImage, sesacLabel, sesacDescriptionLabel].forEach {
            contentView.addSubview($0)
        }
        shopImage.layer.cornerRadius = 8
        shopImage.layer.borderWidth = 1
        shopImage.layer.borderColor = SLPAssets.CustomColor.gray2.color.cgColor
        sesacDescriptionLabel.numberOfLines = 0
        sesacDescriptionLabel.textColor = .black
        sesacDescriptionLabel.font = .systemFont(ofSize: 14)
    }
    
    func setConstraints() {
        shopImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        sesacLabel.snp.makeConstraints { make in
            make.top.equalTo(shopImage.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(13)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(26)
        }
        sesacDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(72)
        }
    }
    
    func configure(indexPath: IndexPath, item:  SeSACIconCollectionSectionModel.Item) {
        shopImage.image = UIImage(named: item.imageString)
        sesacLabel.text = item.titleText
        sesacDescriptionLabel.text = item.descriptionText
    }
}
