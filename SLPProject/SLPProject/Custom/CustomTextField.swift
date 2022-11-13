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


final class CustomOnlyNumberTextField: UITextField {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        let allowedCharacters = "0123456789"
        let allowedCharcterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharcterSet = CharacterSet(charactersIn: string)
        if  allowedCharcterSet.isSuperset(of: typedCharcterSet)
                ,count <= 6 {
            return true
        } else {
            return false
        }
    }
}
