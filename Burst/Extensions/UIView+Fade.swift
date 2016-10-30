import BurstAPI

fileprivate let OpacityAnimationDuration = 0.3

extension UIView {

    class func fadeIn(view: UIView, duration: TimeInterval = OpacityAnimationDuration, completion: EmptyCallback?) {
        animateOpacity(ofView: view, from: 0, to: 1, duration: duration, completion: completion)
    }

    class func fadeOut(view: UIView, duration: TimeInterval = OpacityAnimationDuration, completion: EmptyCallback?) {
        animateOpacity(ofView: view, from: 1, to: 0, duration: duration, completion: completion)
    }
    
    class func animateOpacity(ofView view: UIView,
                              from: CGFloat,
                              to: CGFloat,
                              duration: TimeInterval,
                              completion: EmptyCallback?) {
        view.alpha = from
        UIView.animate(
            withDuration: duration,
            animations: {
                view.alpha = to
            },
            completion: { finished in
                completion?()
            }
        )
    }
}
