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
    var kviewModel: BaseViewModel? {
        didSet {
            bindViewModel()
        }
    }
    private lazy var loaderViewController: LoaderViewController = {
        let controller = LoaderViewController()
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }()

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
                padding: .kinit(bottom: 8)
            )
        }
    }
    
    func addTapGestures() {}
    
    func bindViewModel() {
        kviewModel?.showLoader = { [weak self] show in
            self?.showLoader(show)
        }
        
        kviewModel?.showMessage = { [weak self] config in
            self?.showMessage(config: config)
        }
        
        kviewModel?.showNextPage = { [weak self] in
            runOnMainThread {
                self?.showNextPage()
            }
        }
    }
    
    func showLoader(_ show: Bool) {
        if show {
            kpresent(vc: loaderViewController)
        } else {
            loaderViewController.kdismiss()
        }
    }
    
    func showMessage(config: FeedbackConfig) {
        runOnMainThread { [weak self] in
            self?.showFeedbackController(config: config)
        }
    }
    
    func showNextPage() {
        guard let kviewModel else { return }
        let pageName = kviewModel.preference.DJAuthStep.name
        switch pageName {
        case .countries:
            if kviewModel.preference.DJCanSeeCountryPage {
                let viewController = CountryPickerViewController()
                kpush(viewController)
            } else {
                kviewModel.setNextAuthStep()
            }
        case .userData:
            break
        case .phoneNumber:
            break
        case .address:
            break
        case .email:
            break
        case .governmentData:
            let controller = GovernmentDataViewController()
            kpush(controller)
        case .governmentDataVerification:
            break
        case .businessData:
            break
        case .selfie:
            break
        case .id:
            break
        case .businessID:
            break
        case .additionalDocument:
            break
        case .index:
            break
        case .idOptions:
            break
        }
    }

}

extension DJBaseViewController: DJNavBarViewDelegate {
    func didTapBack() {
        kpop()
    }
    
    func didDismiss() {
        kpop()
    }
}
