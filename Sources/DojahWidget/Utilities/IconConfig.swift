//
//  SelectableItemIconConfig.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

struct IconConfig {
    let icon: UIImage?
    let size: CGSize
    let contentMode: UIView.ContentMode
    
    init(
        icon: UIImage? = nil,
        size: CGSize = .zero,
        contentMode: UIView.ContentMode = .scaleAspectFit
    ) {
        self.icon = icon
        self.size = size
        self.contentMode = contentMode
    }
}
