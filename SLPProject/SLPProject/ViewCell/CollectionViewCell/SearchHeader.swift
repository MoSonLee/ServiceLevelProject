//
//  SearchHeader.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/23.
//

import UIKit

final class SearchHeader: UICollectionReusableView {
    
    static var identifier: String {
        return "SearchHeader"
    }
    
    var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        addSubview(headerLabel)
    }
    
    private func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(18)
        }
    }
    
    func configure(indexPath: IndexPath, item: SearchCollecionSectionModel) {
        headerLabel.text = item.header
    }
}
