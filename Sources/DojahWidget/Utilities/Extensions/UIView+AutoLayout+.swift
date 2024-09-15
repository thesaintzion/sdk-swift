//
//  UIView+AutoLayout+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIView {
    
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero
    ) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        [
            anchoredConstraints.top,
            anchoredConstraints.leading,
            anchoredConstraints.bottom,
            anchoredConstraints.trailing,
            anchoredConstraints.width,
            anchoredConstraints.height
        ].forEach { $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }
    
    func centerYInSuperview(offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY, constant: offset).isActive = true
        }
    }
    
    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        if let centerX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
    }
    
    @discardableResult func constraintWidth(_ constant: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(equalToConstant: constant)
        widthConstraint.isActive = true
        return widthConstraint
    }
    
    @discardableResult func constraintHeight(_ constant: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: constant)
        heightConstraint.isActive = true
        return heightConstraint
    }
    
    @discardableResult func withRadius(_ constant: CGFloat) -> Self {
        viewCornerRadius = constant
        return self
    }
    
    @discardableResult func withHeight(_ constant: CGFloat) -> Self {
        constraintHeight(constant)
        return self
    }
    
    @discardableResult func withWidth(_ constant: CGFloat) -> Self {
        constraintWidth(constant)
        return self
    }
    
    @discardableResult func withSize(width: CGFloat, height: CGFloat) -> Self {
        constraintSize(height: height, width: width)
        return self
    }
    
    @discardableResult func withSize(_ size: CGFloat) -> Self {
        constraintSize(height: size, width: size)
        return self
    }
    
    func constraintSize(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func constraintSize(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    func constraintSize(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    
    func centerHorizontally(to constraint: NSLayoutXAxisAnchor) {
        centerXAnchor.constraint(equalTo: constraint).activate()
    }
    
    func centerVertically(to constraint: NSLayoutYAxisAnchor) {
        centerYAnchor.constraint(equalTo: constraint).activate()
    }
    
    func centerIn(_ parentView: UIView) {
        centerXAnchor.constraint(equalTo: parentView.centerXAnchor).activate()
        centerYAnchor.constraint(equalTo: parentView.centerYAnchor).activate()
    }
    
    func heightEquals(_ view: UIView) {
        heightAnchor.constraint(equalTo: view.heightAnchor).activate()
    }
    
    func widthEquals(_ view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).activate()
    }
}

struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIEdgeInsets {
    static func kinit(
        top: CGFloat = 0,
        left: CGFloat = 0,
        bottom: CGFloat = 0,
        right: CGFloat = 0
    ) -> UIEdgeInsets {
        .init(
            top: top,
            left: left,
            bottom: bottom,
            right: right
        )
    }
    
    static func kinit(allEdges: CGFloat = 0) -> UIEdgeInsets {
        .init(
            top: allEdges,
            left: allEdges,
            bottom: allEdges,
            right: allEdges
        )
    }
    
    static func kinit(
        topBottom: CGFloat = 0,
        leftRight: CGFloat = 0
    ) -> UIEdgeInsets {
        .init(
            top: topBottom,
            left: leftRight,
            bottom: topBottom,
            right: leftRight
        )
    }
}

extension NSLayoutConstraint {
    func activate(_ activate: Bool = true) {
        isActive = activate
    }
}
