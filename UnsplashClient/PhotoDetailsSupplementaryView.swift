//
//  PhotoDetailsSupplementaryView.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 26/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

class PhotoDetailsSupplementaryView: UICollectionReusableView {

    @IBOutlet private weak var categoryTitle: UILabel!
    
    @IBOutlet private weak var authorTitle: UILabel!
    
    @IBOutlet weak var downloadImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        downloadImage.layer.borderWidth = 1
        downloadImage.layer.borderColor = UIColor.blackColor().CGColor
        downloadImage.layer.cornerRadius = 3
        // Initialization code
    }
    
    func prepareForVisibility(photo: Photo){
        
        authorTitle.text = photo.uploader.name.uppercaseString
        guard let category = photo.categories?.first?.categoryTitle else {
            categoryTitle.text = "None".uppercaseString
            return
        }
        self.backgroundColor = photo.color
        categoryTitle.text = category.uppercaseString
    }
    
    override func prepareForReuse() {
        categoryTitle.text = .None
        authorTitle.text = .None
    }
    
}
