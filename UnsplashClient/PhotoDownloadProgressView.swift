//
//  PhotoDownloadProgressView.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 02/07/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

private let InitialCount = 0

class PhotoDownloadProgressView: UIView {

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!

    private var itemCount = InitialCount
    private var currentItem = InitialCount
    
    var updatedState = false
    
    override func awakeFromNib() {
        progressView.progressTintColor = .whiteColor()
        leftLabel.text = String(1)
        rightLabel.text = String(itemCount)
    }
    
    func addDownloadItem() {
        itemCount += 1
        rightLabel.text = String(itemCount)
    }
    
    func addCurrentItem() {
        currentItem += 1
        leftLabel.text = String(currentItem)
        updatedState = true
    }
    
    func setProgress(progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    func resetStateWithCount(hide: EmptyCallback){
        progressView.progress = 0
        updatedState = false
        if currentItem == itemCount {
            currentItem = InitialCount
            itemCount = InitialCount
            leftLabel.text = String(currentItem)
            rightLabel.text = String(itemCount)
            hide()
        }
    }
   
    static func createFromNib() -> PhotoDownloadProgressView? {
        guard let nibName = nibName() else { return nil }
        guard let view = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil).last as? PhotoDownloadProgressView else { return nil }
        return view
    }
    
    static func nibName() -> String? {
        guard let n = NSStringFromClass(PhotoDownloadProgressView.self).componentsSeparatedByString(".").last else { return nil }
        return n
    }
    
}
