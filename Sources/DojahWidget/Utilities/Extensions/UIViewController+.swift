//
//  UIViewController.swift
//
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit

extension UIViewController {
    
    func setUserInterfaceStyle(style: UIUserInterfaceStyle = .light) {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = style
        }
    }
    
    func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    func enableSwipeBackToPopGesture(_ enable: Bool = true) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func showNavigationBarButton(_ status: Bool) {
        if !status {
            navigationItem.rightBarButtonItem?.customView?.alpha = 0.5
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.customView?.alpha = 1
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    var kwidth: CGFloat { UIScreen.main.bounds.width }
    
    var kheight: CGFloat { UIScreen.main.bounds.height }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    var topAnchor: NSLayoutYAxisAnchor? { view.topAnchor }
    
    var bottomAnchor: NSLayoutYAxisAnchor? { view.bottomAnchor }
    
    var leadingAnchor: NSLayoutXAxisAnchor? { view.leadingAnchor }
    
    var trailingAnchor: NSLayoutXAxisAnchor? { view.trailingAnchor }
    
    var safeAreaTopAnchor: NSLayoutYAxisAnchor? { view.safeAreaLayoutGuide.topAnchor }
    
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor? { view.safeAreaLayoutGuide.bottomAnchor }
    
    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor? { view.safeAreaLayoutGuide.leadingAnchor }
    
    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor? { view.safeAreaLayoutGuide.trailingAnchor }
    
    var backgroundColor: UIColor? {
        get { view.backgroundColor }
        set { view.backgroundColor = newValue }
    }
    
    func showNavBar(_ show: Bool = true) {
        navigationController?.navigationBar.isHidden = !show
        navigationController?.setNavigationBarHidden(!show, animated: true)
        navigationController?.isNavigationBarHidden = !show
    }
    
    func setBackButtonText(_ text: String = "") {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
    }
    
    func showBackButton(_ show: Bool = true) {
        navigationItem.setHidesBackButton(!show, animated: true)
    }
    
    func showTabBar(_ show: Bool = true) {
        tabBarController?.tabBar.isHidden = !show
    }
    
    func kpop(animated: Bool = true) {
        runOnMainThread { [weak self] in
            self?.navigationController?.popViewController(animated: animated)
        }
    }
    
    func kpopToRoot(animated: Bool = true) {
        runOnMainThread { [weak self] in
            self?.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    func kpush(_ viewcontroller: UIViewController, animated: Bool = true) {
        runOnMainThread { [weak self] in
            self?.navigationController?.pushViewController(viewcontroller, animated: animated)
        }
    }
    
    func kpresent(vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        runOnMainThread { [weak self] in
            self?.navigationController?.present(vc, animated: animated, completion: completion)
        }
    }
    
    func kdismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        runOnMainThread { [weak self] in
            self?.dismiss(animated: animated, completion: completion)
        }
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        runOnMainThread { [weak self] in
            if let vc = self?.navigationController?.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
                self?.navigationController?.popToViewController(vc, animated: animated)
            }
        }
    }
    
    func setViewControllers(using viewController: UIViewController, animate: Bool = false) {
        runOnMainThread { [weak self] in
            self?.navigationController?.setViewControllers([viewController], animated: animate)
        }
    }
    
    func showMessage(_ message: String, type: ToastType = .success) {
        Toast.shared.show(message, type: type)
    }
    
    func setBackgroundColor(_ color: UIColor = .aSystemBackground) {
        backgroundColor = color
    }
    
    func showSelectableItemsViewController(
        title: String,
        items: [SelectableItem],
        height: CGFloat,
        delegate: SelectableItemsViewDelegate? = nil
    ) {
        let viewController = SelectableItemsViewController(
            title: title,
            items: items,
            height: height,
            delegate: delegate
        )
        present(viewController, animated: true)
    }
    
    func showFeedbackController(config: FeedbackConfig) {
        runOnMainThread { [weak self] in
            let controller = FeedbackViewController(config: config)
            self?.kpush(controller)
        }
    }
    
}
