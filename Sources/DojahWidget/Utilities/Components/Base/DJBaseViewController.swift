//
//  DJBaseViewController.swift
//  
//
//  Created by Isaac Iniongun on 27/10/2023.
//

import UIKit
import CoreLocation

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
    let attachmentManager = AttachmentManager.shared
    let locationManager = LocationManager.shared

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
            runOnMainThread {
                self?.showLoader(show)
            }
        }
        
        kviewModel?.showMessage = { [weak self] config in
            self?.showMessage(config: config)
        }
        
        kviewModel?.showNextPage = { [weak self] in
            runOnMainThread {
                self?.showNextPage()
            }
        }
        
        kviewModel?.errorDoneAction = { [weak self] in
            runOnMainThread {
                self?.kpop()
            }
        }
        
        kviewModel?.showGovtIDPage = { [weak self] govtID in
            runOnMainThread {
                self?.showGovernmentIDViewController(govtID)
            }
        }
        
        kviewModel?.verificationDoneAction = { [weak self] in
            runOnMainThread {
                self?.kpopToRoot()
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
        kprint("navigationController.isNil: \(navigationController.isNil)")
        guard let kviewModel else { return }
        let pageName = kviewModel.preference.DJAuthStep.name
        switch pageName {
        case .countries:
            if kviewModel.preference.DJCanSeeCountryPage {
                kprint("show countries")
                let viewController = CountryPickerViewController()
                kpush(viewController)
            } else {
                kprint("don't show countries")
                kviewModel.setNextAuthStep()
            }
        case .userData:
            let controller = UserDataViewController()
            kpush(controller)
        case .phoneNumber:
            break
        case .address:
            didChooseAddressVerification()
        case .email:
            break
        case .governmentData:
            let controller = GovernmentDataViewController()
            kpush(controller)
        case .governmentDataVerification:
            guard let verificationMode = kviewModel.preference.DJSelectedGovernmentIDVerificationMethod?.verificationModeParam else { return }
            if verificationMode == "OTP" {
                let controller = VerifyOTPViewController()
                kpush(controller)
            } else {
                didChooseLiveness()
            }
        case .businessData:
            let controller = BusinessDataViewController()
            kpush(controller)
        case .selfie:
            break
        case .id, .businessID, .additionalDocument:
            let controller = GovtIDCaptureViewController()
            kpush(controller)
        case .index:
            break
        case .idOptions:
            let controller = GovtIDOptionsViewController()
            kpush(controller)
        case .signature:
            showToast(message: "show signature ui")
        }
    }
    
    private func didChooseLiveness() {
        if attachmentManager.hasCameraPermission {
            showSelfieVideoController()
        } else {
            let controller = PermissionViewController(permissionType: .camera) { [weak self] in
                self?.attachmentManager.requestCameraPermission(success:  { [weak self] in
                    self?.showSelfieVideoController()
                })
            }
            controller.modalPresentationStyle = .overCurrentContext
            kpresent(vc: controller)
        }
    }
    
    private func showSelfieVideoController() {
        let controller = SelfieVideoKYCViewController()
        kpush(controller)
    }
    
    private func didChooseAddressVerification() {
        locationManager.didChangeAuthorization = { [weak self] status in
            self?.didChangeLocationAuthorization(status)
        }
        if locationManager.hasLocationPermission {
            showAddressVerificationController()
        } else {
            let controller = PermissionViewController(permissionType: .location) { [weak self] in
                self?.locationManager.requestAuthorization()
            }
            controller.modalPresentationStyle = .overCurrentContext
            kpresent(vc: controller)
        }
    }
    
    private func didChangeLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            showAddressVerificationController()
        case .notDetermined, .restricted, .denied:
            showToast(message: "Location services are required for address verification", type: .error)
        @unknown default:
            showToast(message: "Location services are required for address verification", type: .error)
        }
    }
    
    private func showAddressVerificationController() {
        let controller = AddressVerificationViewController()
        kpush(controller)
    }
    
    func didTapNavBackButton() {
        kviewModel?.setNextAuthStep(step: -1)
        kpop()
    }
    
    func didTapNavCloseButton() {
        kviewModel?.setNextAuthStep(step: -1)
        kpop()
    }
    
    private func showGovernmentIDViewController(_ govtID: DJGovernmentID) {
        let viewModel = GovtIDCaptureViewModel(selectedID: govtID)
        let controller = GovtIDCaptureViewController(viewModel: viewModel)
        kpush(controller)
    }

}

extension DJBaseViewController: DJNavBarViewDelegate {
    func didTapBack() {
        didTapNavBackButton()
    }
    
    func didDismiss() {
        didTapNavCloseButton()
    }
}
