//
//  UIColor+Darkness.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 28/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

extension UIColor {

    func isLight() -> Bool
    {
        let components = CGColorGetComponents(self.CGColor)
        let componentFirstColor = components[0]
        let componentSecondColor = components[1]
        let brightness = ((componentFirstColor * 299) + (componentSecondColor * 587) + (components[2] * 114))
        
        if brightness < 700
        {
            return false
        }
        else
        {
            return true
        }
    }
    
}