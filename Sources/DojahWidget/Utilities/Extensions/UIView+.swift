//
//  UIView+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

//MARK: - Custom UIViewTapGestureRecognizer
public class UIViewTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

extension UIView {
    static func spacer(_ height: CGFloat = 10) -> UIView {
        UIView(height: height, backgroundColor: .clear)
    }
    
    static func hspacer(_ width: CGFloat = 10) -> UIView {
        UIView(width: width, backgroundColor: .clear)
    }
    
    static func separatorLine(_ color: UIColor = .aSeparator) -> UIView {
        UIView(height: 1, backgroundColor: color)
    }
    
    convenience init(
        subviews: [UIView]? = nil,
        height: CGFloat? = nil,
        width: CGFloat? = nil,
        size: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        borderColor: UIColor? = nil,
        radius: CGFloat? = nil
    ) {
        self.init()
        if let subviews = subviews {
            addSubviews(subviews)
        }
        if let height = height {
            constraintHeight(height)
        }
        if let width = width {
            constraintWidth(width)
        }
        if let size = size {
            constraintSize(size)
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let radius = radius {
            viewCornerRadius = radius
        }
        if let borderWidth = borderWidth {
            viewBorderWidth = borderWidth
        }
        if let borderColor = borderColor {
            self.borderColor = borderColor
        }
    }
    
    var id: String? {
        get { accessibilityIdentifier }
        set { accessibilityIdentifier = newValue }
    }
    
    func addRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addTapGesture(action: @escaping () -> Void ){
        let tap = UIViewTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    
    @objc func handleTap(_ sender: UIViewTapGestureRecognizer) {
        sender.action!()
    }
    
    func fadeIn(
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }
    ) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(
        duration: TimeInterval = 0.5,
        delay: TimeInterval = 0.0,
        completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }
    ) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
    
    func addDropShadow(
        color: UIColor = .darkGray,
        opacity: Float = 0.5,
        offSet: CGSize = CGSize(width: -1, height: 1),
        radius: CGFloat = 5,
        scale: Bool = true
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addCornerRadius(radius: CGFloat = 5, maskToBounds: Bool = true) {
        layer.cornerRadius = radius
        layer.masksToBounds = maskToBounds
    }
    
    func showView(_ show: Bool = true) {
        isHidden = !show
    }
    
    func animateView(duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.5
        }) { completed in
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 1
                completion?()
            })
        }
    }
    
    func animateOnTap(
        scaleX: CGFloat = 0.94,
        scaleY: CGFloat = 1,
        duration: Double = 0.1
    ) {
        breathe(
            scaleX: scaleX,
            scaleY: scaleY,
            duration: duration,
            options: []
        ) { [weak self] in
            guard let self = self else {
                return
            }
            self.stopBreathing()
        }
    }
    
    func didTap(duration: TimeInterval = 0.15, completion: (() -> Void)? = nil) {
        addTapGesture {
            self.animateOnTap()
            runAfter(duration) {
                completion?()
            }
        }
    }
    
    func enableUserInteraction(_ enable: Bool = true) {
        isUserInteractionEnabled = enable
    }
    
    var width: CGFloat { frame.size.width }
    
    var height: CGFloat { frame.size.height }
    
    var minY: CGFloat { frame.minY }
    
    var maxY: CGFloat { frame.maxY }
    
    var minX: CGFloat { frame.minX }
    
    var maxX: CGFloat { frame.maxX }
    
    var x: CGFloat {
        get { frame.origin.x }
        set { frame.origin.x = newValue }
    }
    
    var y: CGFloat {
        get { frame.origin.y }
        set { frame.origin.y = newValue }
    }
    
    func clearBackground() {
        backgroundColor = .clear
    }
    
    func applyShadow(radius:CGFloat = 5){
        layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.09).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = radius
        layer.shadowOffset = .init(width: 0, height: radius)
        
    }
    
    func applyShadowWith(radius: CGFloat) {
        var shadowLayer: CAShapeLayer!

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
            shadowLayer.fillColor = UIColor.clear.cgColor
            shadowLayer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.09).cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .init(width: 0, height: 10)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 5
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    func bringToFront(_ views: UIView...) {
        views.forEach { bringSubviewToFront($0) }
    }
    
    func faded(_ fade: Bool = true, alpha: CGFloat = 0.7) {
        self.alpha = fade ? alpha : 1
    }
}

extension Array where Element == UIView {
    func addClearBackground() {
        forEach { $0.clearBackground() }
    }
    
    func showViews(_ show: Bool = true) {
        forEach { $0.showView(show) }
    }
    
    func enableUserInteraction(_ enable: Bool = true) {
        forEach { $0.enableUserInteraction(enable) }
    }
    
    func addRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        forEach { $0.addRoundCorners(corners, radius: radius) }
    }
    
    func faded(_ fade: Bool = true, alpha: CGFloat = 0.7) {
        forEach { $0.faded(fade, alpha: alpha) }
    }
}

extension Array where Element == UITableView {
    func scrollable(_ scrollable: Bool = true) {
        forEach { $0.scrollable(scrollable) }
    }
}

func animateView(
    duration: TimeInterval = 0.5,
    delay: TimeInterval = 0.0,
    completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in },
    codeToAnimate: @escaping () -> Void
) {
    UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        codeToAnimate()
    }, completion: completion)
}

func kanimate(duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: duration, animations: {
        completion?()
    })
}
