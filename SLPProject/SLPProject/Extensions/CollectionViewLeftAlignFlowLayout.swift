//
//  CollectionViewLeftAlignFlowLayout.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/24.
//

import UIKit

extension UICollectionView {
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width / 2 - (spacing * 3)
        layout.itemSize = CGSize(width: width, height: width * (279 / 165))
        return layout
    }
}

final class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.sectionInset = UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let cellSpacing: CGFloat = 8
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}

