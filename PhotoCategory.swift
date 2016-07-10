//
//  PhotoCategory.swift
//  Burst
//
//  Created by Mindaugas Jucius on 25/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import Unbox

class PhotoCategoryLinks: NSObject, Unboxable {
    
    let photos: NSURL
    let linkToSelf: NSURL //wtf is this?
    
    required init(unboxer: Unboxer) {
        self.photos = unboxer.unbox("photos")
        self.linkToSelf = unboxer.unbox("self")
    }

}

class PhotoCategory: NSObject, Unboxable {
    
    let id: Int
    let photoCount: Int
    let categoryTitle: String
    let links: PhotoCategoryLinks
    
    required init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.links = unboxer.unbox("links")
        self.photoCount = unboxer.unbox("photo_count")
        self.categoryTitle = unboxer.unbox("title")
    }
    
}
