//
//  SeSACShopViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift

final class SeSACShopViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        setComponentsValue()
    }
    
    private func setConstraints() { }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        navigationItem.title = "새싹샵"
    }
}
