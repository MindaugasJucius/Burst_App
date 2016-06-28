//
//  Photo.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 20/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import Unbox

class Photo: NSObject, Unboxable {

    let id: String
    let likes: NSInteger
    let urls: URLs
    let uploader: User
    let fullSize: CGSize
    let categories: [PhotoCategory]?
    let color: UIColor
     
    var thumbImage: UIImage?
    
    required init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.urls = unboxer.unbox("urls")
        self.likes = unboxer.unbox("likes")
        self.uploader = unboxer.unbox("user")
        self.categories = unboxer.unbox("categories")
        let hexString: String = unboxer.unbox("color")
        self.color = UIColor.colorWithHexString(hexString)
        let height: CGFloat = unboxer.unbox("height")
        let width: CGFloat = unboxer.unbox("width")
        self.fullSize = CGSizeMake(width, height)
    }
    
}
