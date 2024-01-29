//
//  SelfieVideoKYCViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit
import AVFoundation

final public class SelfieVideoKYCViewController: DJBaseViewController {

    private let viewModel: SelfieVideoKYCViewModel
    private var viewState = SelfieVideoKYCViewState.captureRecord
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(viewModel: SelfieVideoKYCViewModel = SelfieVideoKYCViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    public static func newInstance() -> SelfieVideoKYCViewController { SelfieVideoKYCViewController() }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var topHintView = PillTextView(
        text: viewState.hintText, //"Place your face in the circle and click \(viewModel.verificationMethod.kycText)",
        textColor: .white,
        bgColor: .black
    )
    private lazy var cameraHintView = PillTextView(
        text: "Loading camera...",
        textColor: .white,
        bgColor: .black
    )
    private lazy var cameraBorderViewWidth = view.width - 100
    private lazy var cameraContainerViewWidth = cameraBorderViewWidth - 30
    private lazy var cameraViewWidth = cameraBorderViewWidth - 32
    private lazy var cameraContainerView = UIView(
        size: cameraContainerViewWidth,
        backgroundColor: .djBorder.withAlphaComponent(0.3),
        radius: cameraContainerViewWidth / 2,
        clipsToBounds: false
    )
    private lazy var cameraView = UIView(
        size: cameraViewWidth,
        backgroundColor: .djBorder.withAlphaComponent(0.3),
        radius: cameraViewWidth / 2,
        clipsToBounds: true
    )
    private lazy var cameraBorderView = UIView(
        size: cameraBorderViewWidth,
        radius: cameraBorderViewWidth / 2,
        clipsToBounds: false
    )
    private lazy var cameraBorderStackView = cameraBorderView.withHStackCentering()
    private lazy var selfieImageView = UIImageView(
        image: .res(.femaleSelfie),
        contentMode: .scaleAspectFill,
        size: cameraViewWidth,
        cornerRadius: cameraViewWidth / 2
    )
    private let bottomHintView = PillIconTextView(
        text: "Please make sure you are in a well lit environment",
        font: .light(13),
        icon: .res(.redInfoCircle),
        iconSize: 18,
        textColor: .djRed,
        bgColor: .djLightRed,
        cornerRadius: 15
    )
    private lazy var bottomHintStackView = bottomHintView.withHStackCentering()
    private let disclaimerItemsView = DisclaimerItemsView(items: DJConstants.selfieCaptureDisclaimerItems)
    private lazy var primaryButton = DJButton(title: "\(viewModel.verificationMethod.kycText)") { [weak self] in
        self?.didTapPrimaryButton()
    }
    private lazy var secondaryButton = DJButton(
        title: "Retake",
        font: .medium(15),
        backgroundColor: .primaryGrey,
        textColor: .aLabel,
        borderWidth: 1,
        borderColor: .djBorder
    ) { [weak self] in
        self?.didTapSecondaryButton()
    }
    private lazy var selfieImageStackView = selfieImageView.withHStackCentering()
    private lazy var contentStackView = VStackView(
        subviews: [topHintView.withHStackCentering(), cameraBorderStackView, bottomHintStackView,
                   disclaimerItemsView, secondaryButton, primaryButton],
        spacing: 40
    )
    private lazy var contentScrollView = UIScrollView(children: [contentStackView])
    private var cameraContainerLayer: CAShapeLayer?
    private var cameraBorderLayer: CAShapeLayer?
    private var isInitialCameraBorders = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar(false)
        setupUI()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        runAfter { [weak self] in
            self?.setBorders()
        }
    }
    
    private func setupUI() {
        viewModel.viewProtocol = self
        with(contentScrollView) {
            addSubview($0)
            
            $0.anchor(
                top: navView.bottomAnchor,
                leading: safeAreaLeadingAnchor,
                bottom: poweredView.topAnchor,
                trailing: safeAreaTrailingAnchor,
                padding: .kinit(leftRight: 20)
            )
            
            contentStackView.anchor(
                top: $0.ktopAnchor,
                leading: $0.kleadingAnchor,
                bottom: $0.kbottomAnchor,
                trailing: $0.ktrailingAnchor,
                padding: .kinit(top: 40, bottom: 20)
            )
            contentStackView.setCustomSpacing(15, after: selfieImageStackView)
            contentStackView.setCustomSpacing(15, after: secondaryButton)
            contentStackView.setCustomSpacing(20, after: disclaimerItemsView)
        }
        
        [disclaimerItemsView, secondaryButton].showViews(false)
        
        attachmentManager.imagePickedHandler = { [weak self] uiimage, imageURL, sourceType in
            self?.didPickImage(uiimage, at: imageURL, using: sourceType)
        }
        
        cameraBorderView.addSubview(cameraContainerView)
        cameraContainerView.centerInSuperview()
        cameraContainerView.addSubviews(selfieImageView, cameraView)
        [cameraView, selfieImageView].centerInSuperview()
        cameraView.addSubview(cameraHintView)
        cameraHintView.centerInSuperview()
        selfieImageView.showView(false)
        
        runAfter { [weak self] in
            self?.setupCameraView()
        }
    }
    
    private func setupCameraView() {
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            kprint("Front camera not available.")
            cameraHintView.text = "Camera loading error."
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)

            if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(photoOutput)

                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = .resizeAspectFill
                guard let previewLayer else { return }
                cameraHintView.showView(false)
                cameraView.clearBackground()
                previewLayer.frame = cameraView.layer.bounds
                cameraView.layer.insertSublayer(previewLayer, at: 0)
                
                startCaptureSession()
            }
        } catch {
            kprint("Error setting up camera input: \(error.localizedDescription)")
        }
    }
    
    private func setBorders() {
        if isInitialCameraBorders {
            cameraContainerLayer = setDashedBorder(
                on: cameraContainerView,
                lineWidth: 2,
                strokeColor: .primary
            )
            cameraBorderLayer = setDashedBorder(
                on: cameraBorderView,
                dashLength: 4,
                dashSpacing: 8,
                lineWidth: 10,
                lineDashPhase: 2,
                strokeColor: .djBorder
            )
        } else {
            removeLayer(cameraContainerLayer, from: cameraContainerView)
            removeLayer(cameraBorderLayer, from: cameraBorderView)
            cameraBorderLayer = setDashedBorder(
                on: cameraBorderView,
                dashLength: 6,
                dashSpacing: 6,
                lineWidth: 4,
                strokeColor: .djGreen
            )
        }
        
    }
    
    private func didPickImage(
        _ uiimage: UIImage,
        at imageURL: URL?,
        using sourceType: UIImagePickerController.SourceType
    ) {
        selfieImageView.image = uiimage
        [disclaimerItemsView, secondaryButton].showViews()
        [topHintView, bottomHintView].showViews(false)
        updateViewState()
    }
    
    private func updateViewState() {
        switch viewState {
        case .captureRecord:
            viewState = .preview
        case .preview:
            break
        }
        updateUIState()
    }
    
    private func updateUIState() {
        primaryButton.title = viewState.primaryButtonTitle
        topHintView.text = viewState.hintText
        switch viewState {
        case .captureRecord:
            break
        case .preview:
            isInitialCameraBorders = false
            [bottomHintStackView, cameraHintView, cameraView].showViews(false)
            [disclaimerItemsView, secondaryButton, selfieImageView].showViews()
        }
    }
    
    private func didTapPrimaryButton() {
        switch viewState {
        case .captureRecord:
            capturePhoto()
            //attachmentManager.openPhotoLibrary(on: self)
        case .preview:
            break
//            let controller = SelfieVideoKYCProcessingViewController(viewModel: viewModel)
//            kpush(controller)
        }
    }
    
    private func didTapSecondaryButton() {
        
    }
    
    private func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .off
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @discardableResult
    private func setDashedBorder(
        on uiview: UIView,
        dashLength: NSNumber = 4,
        dashSpacing: NSNumber = 4,
        lineWidth: CGFloat = 1,
        lineDashPhase: CGFloat = 0,
        strokeColor: UIColor? = .black
    ) -> CAShapeLayer {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = strokeColor?.cgColor
        borderLayer.lineWidth = lineWidth
        borderLayer.lineDashPattern = [dashLength, dashSpacing]
        borderLayer.frame = uiview.bounds
        borderLayer.lineDashPhase = lineDashPhase
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(
            roundedRect: uiview.bounds,
            cornerRadius: uiview.layer.cornerRadius
        ).cgPath
        uiview.layer.addSublayer(borderLayer)
        return borderLayer
    }
    
    private func removeLayer(_ layer: CAShapeLayer?, from uiview: UIView) {
        uiview.layer.sublayers?.removeAll { $0 == layer }
    }
    
    private func startCaptureSession(_ start: Bool = true) {
        runOnBackgroundThread { [weak self] in
            start ? self?.captureSession.startRunning() : self?.captureSession.stopRunning()
        }
    }

}

extension SelfieVideoKYCViewController: SelfieVideoKYCViewProtocol {}

extension SelfieVideoKYCViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let uiImage = UIImage(data: imageData) {
            didCaptureImage(uiImage)
        } else {
            kprint("Error capturing photo: \(error?.localizedDescription ?? "Unknown error")")
            Toast.shared.show("Error taking photo, please try again", type: .error)
        }
    }
    
    private func didCaptureImage(_ uiImage: UIImage) {
        startCaptureSession(false)
        runOnMainThread { [weak self] in
            self?.updateViewState()
            self?.selfieImageView.image = uiImage
        }
    }
}
