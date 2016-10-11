//
//  PhotoCellCollectionViewCell.swift
//  Burst
//
//  Created by Mindaugas Jucius on 23/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit
import BurstAPI

typealias AfterBlur = (_ cell: PhotoCellCollectionViewCell) -> ()
typealias PhotoSaveCallback = (_ photoToDownload: Photo) -> ()

class PhotoCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var categoryTitle: UILabel!
    @IBOutlet fileprivate weak var authorLabel: UILabel!
    @IBOutlet fileprivate weak var shareButton: UIButton!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    @IBOutlet fileprivate weak var blurView: UIView!
    
    fileprivate var longPressRecognizer: UILongPressGestureRecognizer!
    
    var onBlurFinish: AfterBlur?
    var onBlurBegin: EmptyCallback?
    var onSaveTouch: PhotoSaveCallback?
    
    var cellPhoto: Photo?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.alpha = 0
        blurView.isHidden = true
        imageView.contentMode = .topLeft
        addLongPressGesture()
    }
    
    override func prepareForReuse() {
        imageView.image = .none
        blurView.isHidden = true
        blurView.alpha = 0
    }

    func prepareForVisibility(_ photo: Photo){
        cellPhoto = photo
        imageView.image = photo.thumbImage
        authorLabel.text = photo.uploader.name.uppercaseString
        guard let category = photo.categories?.first?.categoryTitle else {
            return
        }
        categoryTitle.text = category.uppercaseString
    }
    
    // MARK: - Private
    
    @objc fileprivate func longPressedWithGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            blur()
        default:
            break
        }
    }
    
    fileprivate func addLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressedWithGesture(_:)))
        gesture.minimumPressDuration = 0.2
        addGestureRecognizer(gesture)
        longPressRecognizer = gesture
    }
    
    // MARK: - Button actions
    
    @IBAction func saveTouched(_ sender: UIButton) {
        guard let photo = cellPhoto else { return }
        onSaveTouch?(photoToDownload: photo)
    }
    
    // MARK: - Animations
    
    func blur() {
        removeGestureRecognizer(longPressRecognizer)
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.blurView.alpha = 1
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            strongSelf.onBlurFinish?(strongSelf)
        }
    }
    
    func clearBlurWithCallback(_ onClearFinish: EmptyCallback?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.blurView.alpha = 0
        }) { [weak self] (finished) in
            guard let strongSelf = self else { return }
            if finished {
                strongSelf.addLongPressGesture()
                strongSelf.blurView.isHidden = true
                onClearFinish?()
            }
        }
    }
    
}
