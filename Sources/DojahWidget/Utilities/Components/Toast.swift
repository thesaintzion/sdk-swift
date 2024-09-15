//
//  Toast.swift
//
//
//  Created by Isaac Iniongun on 25/10/2023.
//

import UIKit

enum ToastType {
    case success, error
}

class Toast: UIView {
    
    static var shared = Toast()
    
    let titleLabel = UILabel(
        text: "Test",
        font: .regular(),
        numberOfLines: 0,
        color: .white,
        alignment: .left
    )
    
    var type: ToastType = .success {
        didSet {
            switch type {
            case .error:
                backgroundColor = .red
            case .success:
                backgroundColor = .djGreen
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 3, left: 20, bottom: 0, right: 5)
        )
        self.isUserInteractionEnabled = true
        titleLabel.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToast)))
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToast)))
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
    }
    
    let currentWindow = UIApplication.shared.keyWindow
    
    @objc func didTapToast() {
        runOnMainThread {
            generateHapticFeedback()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                self.transform = .init(scaleX: 0.95, y: 0.95)
                UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
                    self.transform = .identity
                    self.beginHideToast()
                }, completion: nil)
            })
        }
        
    }
    
    func _hideToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.beginHideToast()
        }
    }
    
    private func beginHideToast() {
        runOnMainThread {
            UIView.animate(
                withDuration: 0.7,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: [],
                animations: {
                    self.transform = .init(translationX: 0, y: -200)
                },
                completion: nil
            )
        }
    }
    
    func show(_ title: String, type: ToastType = .success) {
        runOnMainThread {
            generateHapticFeedback()
            
            self.type = type
            self.titleLabel.text = title
            
            guard let window = UIApplication.shared.keyWindow else { return }
            
            window.addSubview(self)
            window.bringSubviewToFront(self)
            
            self.constraintHeight(notchHeight + 50)
            
            self.anchor(
                top: window.topAnchor,
                leading: window.leadingAnchor,
                trailing: window.trailingAnchor,
                padding: .init(top: 0, left: 0, bottom: 0, right: 0)
            )
            
            self.transform = .init(translationX: 0, y: -200)
            
            UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
                self.transform = .identity
            }, completion: nil)
            
            self._hideToast()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
