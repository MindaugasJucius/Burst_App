//
//  PhotoCellCollectionViewCell.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 23/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

class PhotoCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        roundingView.layer.cornerRadius = 5
//        roundingView.layer.masksToBounds = true
        //imageView.layer.cornerRadius = 5
        imageView.contentMode = .TopLeft
    }
    
    func updateImage(image: UIImage?) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        imageView.image = .None
    }

//    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.applyLayoutAttributes(layoutAttributes)
//        if let attributes = layoutAttributes as? PhotoLayoutCellAttributes {
//            print(imageView.frame.size.height)
//            print(attributes.photoHeight)
//        }
//    }
    
}
