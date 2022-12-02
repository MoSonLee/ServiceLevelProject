//
//  SeSACShopViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SeSACShopViewController: UIViewController {
    
    private let profileImage = UIImageView()
    private let saveButton = UIButton()
    private let sesacButton = UIButton()
    private let backgroundButton = UIButton()
    private let lineView = UIView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let tableView = UITableView()
    private var currentStatus: ShopTabModel = .sesac
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        [profileImage, saveButton, sesacButton, backgroundButton, lineView, collectionView, tableView].forEach {
            view.addSubview($0)
        }
        setComponentsValue()
    }
    
    private func setConstraints() {
        profileImage.snp.makeConstraints { make in
            <#code#>
        }
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        navigationItem.title = "새싹샵"
    }
}
