//
//  DJBaseViewController.swift
//  
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit

public class DJBaseViewController: UIViewController {
    
    let navView = DJNavBarView()
    let poweredView = DJPoweredView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterfaceStyle()
        backgroundColor = .aSystemBackground
        setupNavView()
        setupPoweredView()
        addTapGestures()
    }
    
    private func setupNavView() {
        with(navView) {
            addSubview($0)
            $0.delegate = self
            $0.anchor(
                top: safeAreaTopAnchor,
                leading: safeAreaLeadingAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(top: 10, left: 5, right: 16)
            )
        }
    }
    
    private func setupPoweredView() {
        with(poweredView) {
            addSubview($0)
            $0.centerXInSuperview()
            $0.anchor(
                bottom: safeAreaBottomAnchor,
                padding: .kinit(bottom: 10)
            )
        }
    }
    
    func addTapGestures() {}

}

extension DJBaseViewController: DJNavBarViewDelegate {
    func didTapBack() {
        kpopViewController()
    }
    
    func didDismiss() {
        kpopViewController()
    }
    
}
