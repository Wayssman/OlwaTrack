//
//  UIColor+Extensions.swift
//  OlwaTrack
//
//  Created by Желанов Александр Валентинович on 04.06.2023.
//

import UIKit

extension UIColor {
    convenience init?(_ hex: String) {
        if hex.hasPrefix("#") {
            let hexString = String(hex.dropFirst(1))
            
            if hexString.count == 6 {
                let scanner = Scanner(string: hexString)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    let r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    let g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    let b = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}
