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
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var blurView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        imageView.contentMode = .TopLeft
        addLongPressStateRecognizer()
    }
    
    @objc private func longPressed(gesture: UILongPressGestureRecognizer) {
        blurView.hidden = false
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: {
            [weak self] in
            self?.blurView.alpha = 1
        }) { [weak self] (finished) in
            self?.removeGestureRecognizer(gesture)
            self?.addTapRecognizerForRemovalOfLongPressState()
        }
    }
    
    @objc private func tappedOnLongPressState(gesture: UITapGestureRecognizer) {
        UIView.animateWithDuration(0.2, delay: 0, options: .TransitionCrossDissolve, animations: { [weak self] in
            self?.blurView.alpha = 0
        }) { [weak self] (finished) in
            self?.blurView.hidden = true
            self?.removeGestureRecognizer(gesture)
            self?.addLongPressStateRecognizer()
        }
    }
    
    @objc private func buttonGlowOnTouchDown(button: UIButton) {
//        UIColor *color = button.currentTitleColor;
//        button.titleLabel.layer.shadowColor = [color CGColor];
//        button.titleLabel.layer.shadowRadius = 4.0f;
//        button.titleLabel.layer.shadowOpacity = .9;
//        button.titleLabel.layer.shadowOffset = CGSizeZero;
//        button.titleLabel.layer.masksToBounds = NO;
        let color = UIColor.whiteColor()
        guard let imageViewLayer = button.imageView?.layer else { return }
        
        imageViewLayer.shadowColor = color.CGColor
        imageViewLayer.shadowRadius = 2
        imageViewLayer.shadowOpacity = 1
        imageViewLayer.shadowOffset = CGSizeZero
        imageViewLayer.masksToBounds = false
    }
    
    private func addTapRecognizerForRemovalOfLongPressState() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLongPressState(_:)))
        addGestureRecognizer(gesture)
    }
    
    private func addLongPressStateRecognizer() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        gesture.minimumPressDuration = 0.2
        addGestureRecognizer(gesture)
    }
    
    func prepareForVisibility(photo: Photo){
        imageView.image = photo.thumbImage
        authorLabel.text = photo.uploader.name.uppercaseString
        guard let category = photo.categories?.first?.categoryTitle else {
            categoryTitle.text = "None".uppercaseString
            return
        }
        categoryTitle.text = category.uppercaseString
    }
    
    override func prepareForReuse() {
        imageView.image = .None
        blurView.hidden = true
        //blurView.alpha = 0
        //controlsStackView.hidden = true
    }
    
}
