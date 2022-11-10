//
//  CustomTextField.swift
//  SLPProject
//
//  Created by 이승후 on 2022/11/10.
//

import UIKit

final class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

