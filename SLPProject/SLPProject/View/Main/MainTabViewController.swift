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
        setComponents()
        setConstraints()
    }
    
    private func setTabBar() {
        let tabOne = HomeTabViewController()
        let tabOneBarItem = UITabBarItem(title: "홈", image: SLPAssets.CustomImage.homeIcon.image, tag: 0)
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = UINavigationController(rootViewController: SeSACShopViewController())
        let tabTwoBarItem = UITabBarItem(title: "새싹샵", image: SLPAssets.CustomImage.shopIcon.image, tag: 1)
        tabTwo.tabBarItem = tabTwoBarItem
        
        let tabThree = UINavigationController(rootViewController: SeSACFriendViewController())
        let tabThreeBarItem = UITabBarItem(title: "새싹친구", image: SLPAssets.CustomImage.friendIcon.image, tag: 2)
        tabThree.tabBarItem = tabThreeBarItem
        
        let tabFour = UINavigationController(rootViewController: MyInfoViewController())
        let tabFourBarItem = UITabBarItem(title: "내정보", image: SLPAssets.CustomImage.infoIcon.image, tag: 3)
        tabFour.tabBarItem = tabFourBarItem
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
    }
    
    private func setComponents() {
        setTabBar()
        setComponentsValue()
    }
    
    private func setConstraints() {
        
    }
    
    private func setComponentsValue() {
        view.backgroundColor = SLPAssets.CustomColor.white.color
    }
}
