//
//  DJNavBarView.swift
//  
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit

protocol DJNavBarViewDelegate: AnyObject {
    func didTapBack()
    func didDismiss()
}

final class DJNavBarView: BaseView {
    weak var delegate: DJNavBarViewDelegate?
    private let backImageView = UIImageView(image: .res(.backTextIcon), height: 24, width: 64)
    private let closeImageView = UIImageView(image: .res(.xmarkFilledIcon), size: 18)
    private let orchestrateImageView = UIImageView(image: .res(.orchestrateIcon), height: 20)
    private lazy var contentStackView = HStackView(
        subviews: [backImageView, orchestrateImageView, closeImageView],
        alignment: .center
    )
    
    override func setup() {
        with(contentStackView) {
            addSubview($0)
            $0.fillSuperview()
        }
        addTapGestures()
    }
    
    private func addTapGestures() {
        backImageView.didTap { [weak self] in
            self?.delegate?.didTapBack()
        }
        
        closeImageView.didTap { [weak self] in
            self?.delegate?.didDismiss()
        }
    }
    
    func showNavControls(_ show: Bool) {
        backImageView.showView(show)
        closeImageView.showView(show)
    }
    
    func showNavBackControl(_ show: Bool) {
        backImageView.showView(show)
    }
    
    func showNavCloseControl(_ show: Bool) {
        closeImageView.showView(show)
    }

}
