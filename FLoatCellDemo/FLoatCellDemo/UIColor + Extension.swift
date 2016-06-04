//
//  UIColor + Extension.swift
//  FLoatCellDemo
//
//  Created by ghost on 16/6/4.
//  Copyright © 2016年 ghost. All rights reserved.
//

import UIKit

extension UIColor {
    
    func setGl_color(r : CGFloat,g : CGFloat,b : CGFloat) -> UIColor?{
        
            return UIColor.init(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1)
        }
    func setGl_randomColor() -> UIColor? {
        
         return setGl_color(CGFloat(UInt(arc4random_uniform(UInt32(UInt(255))))), g: CGFloat(UInt(arc4random_uniform(UInt32(UInt(255))))), b: CGFloat(UInt(arc4random_uniform(UInt32(UInt(255))))))
    }
           
}
