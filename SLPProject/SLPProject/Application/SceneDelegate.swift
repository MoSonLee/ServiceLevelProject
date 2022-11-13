//
//  SceneDelegate.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let vc = InitialViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationVC
        
//        if UserDefaults.showOnboarding {
//            let vc = OnBoardingPageViewController()
//            let navigationVC = UINavigationController(rootViewController: vc)
//            window?.rootViewController = navigationVC
//        } else {
//            let vc = GenderViewController()
////            let vc = LoginViewController()
//            let navigationVC = UINavigationController(rootViewController: vc)
//            window?.rootViewController = navigationVC
//        }
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
