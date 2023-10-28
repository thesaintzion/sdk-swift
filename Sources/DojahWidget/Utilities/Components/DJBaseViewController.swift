//
//  DJBaseViewController.swift
//  
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit

public class DJBaseViewController: UIViewController {
    
    let navView = DJNavBarView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        setupNavView()
    }
    
    private func setupNavView() {
        with(navView) {
            addSubview($0)
            $0.delegate = self
            $0.anchor(
                top: safeAreaTopAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(topBottom: 10, leftRight: 16)
            )
        }
    }

}

extension DJBaseViewController: DJNavBarViewDelegate {
    func didTapBack() {
        kpopViewController()
    }
    
    func didDismiss() {
        kpopViewController()
    }
    
}
