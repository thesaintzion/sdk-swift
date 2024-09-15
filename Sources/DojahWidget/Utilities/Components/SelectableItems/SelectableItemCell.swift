//
//  SelectableItemCell.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class SelectableItemCell: BaseTableViewCell {

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel(text: "")
    private lazy var contentStackView = HStackView(
        subviews: [iconImageView, nameLabel],
        spacing: 10,
        alignment: .center
    )
    
    override func setup() {
        clearBackground()
        with(contentStackView) {
            kaddSubview($0)
            $0.fillSuperview(padding: .kinit(topBottom: 10))
        }
    }
    
    func configure(item: SelectableItem) {
        with(item) {
            iconImageView.image = $0.iconConfig.icon
            iconImageView.contentMode = $0.iconConfig.contentMode
            iconImageView.constraintSize($0.iconConfig.size)
            nameLabel.text = $0.title
        }
    }

}
