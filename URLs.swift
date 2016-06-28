//
//  URLs.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 20/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import Unbox

class URLs: NSObject, Unboxable {
    
    let full: NSURL
    let raw: NSURL
    let regular: NSURL
    let small: NSURL
    let thumb: NSURL
    
    required init(unboxer: Unboxer) {
        self.full = unboxer.unbox("full")
        self.raw = unboxer.unbox("raw")
        self.regular = unboxer.unbox("regular")
        self.small = unboxer.unbox("small")
        self.thumb = unboxer.unbox("thumb")
    }
    
}
