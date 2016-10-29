import BurstAPI

fileprivate let OpacityAnimationDuration = 0.3

extension UIView {

    class func fadeIn(view: UIView, completion: EmptyCallback?) {
        animateOpacity(ofView: view, from: 0, to: 1, completion: completion)
    }

    class func fadeOut(view: UIView, completion: EmptyCallback?) {
        animateOpacity(ofView: view, from: 1, to: 0, completion: completion)
    }
    
    class func animateOpacity(ofView view: UIView,
                              from: CGFloat,
                              to: CGFloat,
                              completion: EmptyCallback?) {
        view.alpha = from
        UIView.animate(
            withDuration: OpacityAnimationDuration,
            animations: {
                view.alpha = to
            },
            completion: { finished in
                completion?()
            }
        )
    }
}
