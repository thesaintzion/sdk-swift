//
//  BaseView.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

class BaseView: UIView {
    open func setup() {
        backgroundColor = .aSystemBackground
    }
    
    open func layout() {}
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
