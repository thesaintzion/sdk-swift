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
    private let appImageView = UIImageView(image: .res(.circleIcon), contentMode: .scaleAspectFit)
    
    override func setup() {
        addSubviews(backImageView, closeImageView, appImageView)
        with(appImageView) {
            $0.centerXInSuperview()
            $0.anchor(top: topAnchor, bottom: bottomAnchor)
            backImageView.centerVertically(to: $0.centerYAnchor)
            backImageView.anchor(leading: leadingAnchor)
            closeImageView.centerVertically(to: $0.centerYAnchor)
            closeImageView.anchor(trailing: trailingAnchor)
        }
        
        addTapGestures()
        setAppImage()
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
    
    private func setAppImage() {
        if let appLogoURL = preference.DJAppConfig?.logo {
            appImageView.setImageFromURL(appLogoURL, placeholder: .res(.circleIcon))
        }
    }

}
