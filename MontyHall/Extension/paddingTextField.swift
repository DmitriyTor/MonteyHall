//
//  paddingTextField.swift
//  TinderGamers
//
//  Created by Admin on 04/02/2019.
//  Copyright © 2019 DmitriyToropkin. All rights reserved.
//

import UIKit

//Отступ в текст филд
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
