//
//  DJPoweredView.swift
//  
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit

final class DJPoweredView: BaseView {

    private let poweredLabel = UILabel(text: "Powered by ", font: .regular(13))
    private let djImageView = UIImageView(image: .res("dojahSmallIcon"))
    private lazy var contentStackView = VStackView(
        subviews: [poweredLabel, djImageView],
        spacing: 4,
        alignment: .center
    )
    
    override func setup() {
        with(contentStackView) {
            addSubview($0)
            $0.fillSuperview()
        }
    }

}
