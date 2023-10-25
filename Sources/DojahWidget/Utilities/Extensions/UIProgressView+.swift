//
//  UIProgressView+.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

extension UIProgressView {
    convenience init(
        style: UIProgressView.Style = .bar,
        value: Float? = nil,
        progressTintColor: UIColor = .primary,
        trackTintColor: UIColor = .aSecondaryLabel.withAlphaComponent(0.4),
        height: CGFloat? = nil,
        width: CGFloat? = nil
    ) {
        self.init()
        progressViewStyle = .bar
        if let value = value {
            progress = value
        }
        self.progressTintColor = progressTintColor
        self.trackTintColor = trackTintColor
        if let height = height {
            constraintHeight(height)
        }
        if let width = width {
            constraintWidth(width)
        }
    }
}
