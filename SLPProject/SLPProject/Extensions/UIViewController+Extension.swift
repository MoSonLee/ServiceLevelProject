//
//  RootView.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/13.
//

import UIKit

extension UIViewController {
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        if let window = windowScene?.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String, okTitle: String,completion: @escaping () -> Void) {
        let alert =  UIAlertController(title: title, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style:.destructive, handler: { _ in
            completion()
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String, okTitle: String,completion: @escaping () -> Void) {
        let alert =  UIAlertController(title: title, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style:.destructive, handler: { _ in
            completion()
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
