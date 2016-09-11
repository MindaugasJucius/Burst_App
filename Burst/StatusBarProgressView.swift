//
//  DownloadProgressView.swift
//  Burst
//
//  Created by Mindaugas Jucius on 06/09/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

class StatusBarProgressView: UIView {

    convenience init(frame: CGRect, progress: Float) {
        self.init(frame: frame)
        addProgressView(withFrame: frame, andProgress: progress)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addProgressView(withFrame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addProgressView(withFrame frame: CGRect, andProgress progress: Float = 0) {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .Bar
        progressView.progressTintColor = AppAppearance.lightBlueAppColor()
        progressView.trackTintColor = .whiteColor()
        progressView.progress = progress
        progressView.frame =  frame
        addSubview(progressView)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
