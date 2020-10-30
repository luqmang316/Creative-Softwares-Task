//
//  UIColor+Additions.swift
//  IbottaDevTest
//
//  Created by Muhammad Luqman on 10/25/20.
//

import UIKit

extension UIColor {
    
    /// Hex string convert to color
    class func colorFrom(hexString hexStr : String, alpha: CGFloat ) -> UIColor {
        
        if let rgbValue = UInt(hexStr, radix: 16) {
            
            let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255
            let green =  CGFloat((rgbValue >>  8) & 0xff) / 255
            let blue  =  CGFloat((rgbValue      ) & 0xff) / 255
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            
        } else { // bydefult return black color
            return UIColor.black
        }
    }
}
