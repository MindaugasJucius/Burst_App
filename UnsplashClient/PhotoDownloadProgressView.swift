//
//  PhotoDownloadProgressView.swift
//  UnsplashClient
//
//  Created by Mindaugas Jucius on 02/07/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

class PhotoDownloadProgressView: UIView {

    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!

    
    override func awakeFromNib() {
        leftLabel.text = "0"
        rightLabel.text = "0"
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
