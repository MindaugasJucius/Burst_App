//
//  UIButton+Blur.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 02/07/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

extension UIButton {
    
    func buttonImageAddGlow() {
        let color = UIColor.whiteColor()
        guard let imageViewLayer = self.imageView?.layer else { return }
        imageViewLayer.shadowColor = color.CGColor
        imageViewLayer.shadowRadius = 2
        imageViewLayer.shadowOpacity = 1
        imageViewLayer.shadowOffset = CGSizeZero
        imageViewLayer.masksToBounds = false
    }
    
}
