//
//  UIColor.swift
//  PhotoFinder
//
//  Created by Rupali on 13.11.19.
//  Copyright © 2019 rghate. All rights reserved.
//

import UIKit

extension UIColor {
    static let textColor = rgb(red: 65, green: 52, blue: 60)
    
//    static let textColor: UIColor = .lightGray

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

