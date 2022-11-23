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
    
    private var backButton = UIBarButtonItem()
    
    private let viewModel = SearchStudyViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        setComponentsValue()
        setNavigation()
    }
    
    private func setNavigation() {
        backButton = UIBarButtonItem(image: SLPAssets.CustomImage.backButton.image, style: .plain, target: navigationController, action: nil)
        backButton.tintColor = SLPAssets.CustomColor.black.color
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setConstraints() { }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
    }
}
