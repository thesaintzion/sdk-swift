//
//  FillFormView.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class FillFormView: BaseView {

    private let fillFormLabel = IconUILabel(
        text: "Fill the form as it appears on your valid ID",
        icon: .res(.greenInfoCircle),
        position: .left,
        iconSize: 20,
        iconPadding: 2,
        textColor: .djGreen
    )
    
    override func setup() {
        backgroundColor = .djLightGreen
        viewCornerRadius = 15
        with(fillFormLabel) {
            addSubview($0)
            $0.fillSuperview(padding: .kinit(topBottom: 6, leftRight: 8))
        }
    }

}
