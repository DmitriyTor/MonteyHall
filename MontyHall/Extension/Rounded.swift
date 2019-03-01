//
//  Rounded.swift
//  MontyHall
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 DmitriyToropkin. All rights reserved.
//

import Foundation


//Округление до нужного количества знаков
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
