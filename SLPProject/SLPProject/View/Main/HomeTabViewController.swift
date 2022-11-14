//
//  HomeTabViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/15.
//

import UIKit

final class HomeTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    private func setComponents() {
        setComponentsValue()
    }
    
    private func setConstraints() {
        
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
    }
}
