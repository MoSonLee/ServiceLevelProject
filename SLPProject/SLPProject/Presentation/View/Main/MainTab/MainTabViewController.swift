//
//  MainTabViewController.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/08.
//

import UIKit

final class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    private func setTabBar() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
        
        let vc1 = HomeTabViewController()
        let vc2 = SeSACShopViewController()
        let vc3 = MyInfoViewController()
        
        let firstTabBarItem = UITabBarItem(title: "홈", image: SLPAssets.CustomImage.homeIcon.image, tag: 0)
        let secondTabBarItem = UITabBarItem(title: "새싹샵", image: SLPAssets.CustomImage.shopIcon.image, tag: 1)
        let fourthTabBarItem = UITabBarItem(title: "내정보", image: SLPAssets.CustomImage.homeIcon.image, tag: 2)
        
        vc1.tabBarItem = firstTabBarItem
        vc2.tabBarItem = secondTabBarItem
        vc3.tabBarItem = fourthTabBarItem
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        viewControllers = [nav1, nav2, nav3]
    }
}
