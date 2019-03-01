//
//  hideLineNavBar.swift
//  TinderGamers
//
//  Created by Admin on 04/02/2019.
//  Copyright © 2019 DmitriyToropkin. All rights reserved.
//

import UIKit

//скрыть линию навигейшнбара
extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

