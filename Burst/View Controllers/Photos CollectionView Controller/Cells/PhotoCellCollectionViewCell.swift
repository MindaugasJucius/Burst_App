//
//  PhotoCellCollectionViewCell.swift
//  Burst
//
//  Created by Mindaugas Jucius on 23/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import BurstAPI

typealias AfterBlur = (cell: PhotoCellCollectionViewCell) -> ()
typealias PhotoSaveCallback = (photoToDownload: Photo) -> ()

class PhotoCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var categoryTitle: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var blurView: UIView!
    
    private var longPressRecognizer: UILongPressGestureRecognizer!
    
    var onBlurFinish: AfterBlur?
    var onBlurBegin: EmptyCallback?
    var onSaveTouch: PhotoSaveCallback?
    
    var cellPhoto: Photo?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.alpha = 0
        blurView.hidden = true
        imageView.contentMode = .TopLeft
        addLongPressGesture()
    }
    
    override func prepareForReuse() {
        imageView.image = .None
        blurView.hidden = true
        blurView.alpha = 0
    }

    func prepareForVisibility(photo: Photo){
        cellPhoto = photo
        imageView.image = photo.thumbImage
        authorLabel.text = photo.uploader.name.uppercaseString
        guard let category = photo.categories?.first?.categoryTitle else {
            return
        }
        categoryTitle.text = category.uppercaseString
    }
    
    // MARK: - Private
    
    @objc private func longPressedWithGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .Began:
            blur()
        default:
            break
        }
    }
    
    private func addLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressedWithGesture(_:)))
        gesture.minimumPressDuration = 0.2
        addGestureRecognizer(gesture)
        longPressRecognizer = gesture
    }
    
    // MARK: - Button actions
    
    @IBAction func saveTouched(sender: UIButton) {
        guard let photo = cellPhoto else { return }
        onSaveTouch?(photoToDownload: photo)
    }
    
    // MARK: - Animations
    
    func blur() {
        removeGestureRecognizer(longPressRecognizer)
        blurView.hidden = false
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseOut, animations: { [weak self] in
            self?.blurView.alpha = 1
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.onBlurFinish?(cell: strongSelf)
        }
    }
    
    func clearBlurWithCallback(onClearFinish: EmptyCallback?) {
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: { [weak self] in
            self?.blurView.alpha = 0
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            if finished {
                strongSelf.addLongPressGesture()
                strongSelf.blurView.hidden = true
                onClearFinish?()
            }
        }
    }
    
}
