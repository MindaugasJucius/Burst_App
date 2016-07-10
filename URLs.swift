//
//  URLs.swift
//  Burst
//
//  Created by Mindaugas Jucius on 20/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import Unbox

enum PhotoSize {
    case Full
    case Raw
    case Regular
    case Small
    case Thumb
}

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
    
    init(full: NSURL, raw: NSURL, regular: NSURL, small: NSURL, thumb: NSURL) {
        self.full = full
        self.raw = raw
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}
