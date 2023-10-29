//
//  DottedBorderView.swift
//
//
//  Created by Isaac Iniongun on 29/10/2023.
//

import UIKit

final class DottedBorderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = 1
        dashBorder.strokeColor = UIColor.primary.cgColor
        dashBorder.lineDashPattern = [4, 2]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
        layer.addSublayer(dashBorder)
    }
}
