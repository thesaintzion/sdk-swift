//
//  SelectableItemCell.swift
//  
//
//  Created by Isaac Iniongun on 28/10/2023.
//

import UIKit

final class SelectableItemCell: BaseTableViewCell {

    private let iconImageView = UIImageView(
        image: .res(.ngFlag),
        contentMode: .scaleAspectFill,
        height: 14,
        width: 19
    )
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
            iconImageView.image = $0.icon
            nameLabel.text = $0.title
        }
    }

}
