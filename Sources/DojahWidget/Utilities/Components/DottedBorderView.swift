//
//  DottedBorderView.swift
//
//
//  Created by Isaac Iniongun on 29/10/2023.
//

import UIKit

class DottedBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addDottedBorder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //addDottedBorder()
    }

    private func addDottedBorder() {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor.primary.cgColor
        borderLayer.lineWidth = 1
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: bounds).cgPath
        layer.addSublayer(borderLayer)
    }
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = 1
        dashBorder.strokeColor = UIColor.primary.cgColor
        dashBorder.lineDashPattern = [2, 2] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
