//
//  StackView.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

class VStackView: UIStackView {
    init(
        subviews: [UIView] = [],
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        super.init(frame: .zero)
        subviews.forEach({addArrangedSubview($0)})
        self.spacing = spacing
        self.axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HStackView: UIStackView {
    init(
        subviews: [UIView],
        spacing: CGFloat = 0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        super.init(frame: .zero)
        subviews.forEach({addArrangedSubview($0)})
        self.spacing = spacing
        self.axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
