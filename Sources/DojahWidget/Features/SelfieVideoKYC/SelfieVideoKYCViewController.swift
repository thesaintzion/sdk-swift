//
//  SelfieVideoKYCViewController.swift
//  
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import UIKit
import AVFoundation

final class SelfieVideoKYCViewController: DJBaseViewController {

    private let viewModel: SelfieVideoKYCViewModel
    //private var viewState = SelfieVideoKYCViewState.capture
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(viewModel: SelfieVideoKYCViewModel = SelfieVideoKYCViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        kviewModel = viewModel
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var topHintView = PillTextView(
        text: viewState.hintText,
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
        image: .res("femaleSelfie"),
        contentMode: .scaleAspectFill,
        size: cameraViewWidth,
        cornerRadius: cameraViewWidth / 2
    )
    private let bottomHintView = PillIconTextView(
        text: "Please make sure you are in a well lit environment",
        font: .light(13),
        icon: .res("redInfoCircle"),
        iconSize: 18,
        textColor: .djRed,
        bgColor: .djLightRed,
        cornerRadius: 15
    )
    private lazy var bottomHintStackView = bottomHintView.withHStackCentering()
    private let disclaimerItemsView = DisclaimerItemsView(items: DJConstants.selfieCaptureDisclaimerItems)
    private lazy var primaryButton = DJButton(
        title: "\(viewModel.verificationMethod.kycText)",
        isEnabled: false
    ) { [weak self] in
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
    private var isCaptureCameraBorders = true
    private var selfieImageBlurEffectView: UIVisualEffectView?
    private var viewState: SelfieVideoKYCViewState {
        viewModel.viewState
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        showNavBar(false)
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
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
                padding: .kinit(top: 60, bottom: 20)
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
        cameraContainerView.addSubviews(selfieImageView, cameraView, cameraHintView)
        [cameraView, selfieImageView, cameraHintView].centerInSuperview()
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
                primaryButton.enable()
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
        if isCaptureCameraBorders {
            if let cameraBorderLayer {
                removeLayer(cameraBorderLayer, from: cameraBorderView)
            }
            if let cameraContainerLayer {
                removeLayer(cameraContainerLayer, from: cameraContainerView)
            }
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
        case .capture:
            viewModel.viewState = .previewSelfie
        case .previewSelfie:
            viewModel.viewState = .capture
        case .record:
            viewModel.viewState = .previewSelfieVideo
        case .previewSelfieVideo:
            viewModel.viewState = .record
        }
        updateUIState()
    }
    
    private func updateUIState() {
        primaryButton.title = viewState.primaryButtonTitle
        topHintView.text = viewState.hintText
        isCaptureCameraBorders = [.capture, .record].contains(viewState)
        
        switch viewState {
        case .capture:
            cameraView.backgroundColor = .djBorder.withAlphaComponent(0.3)
            [bottomHintStackView, cameraHintView, cameraView].showViews()
            [disclaimerItemsView, secondaryButton, selfieImageView].showViews(false)
            startCaptureSession()
        case .previewSelfie:
            startCaptureSession(false)
            [bottomHintStackView, cameraHintView, cameraView].showViews(false)
            [disclaimerItemsView, secondaryButton, selfieImageView].showViews()
        case .record:
            cameraView.backgroundColor = .djBorder.withAlphaComponent(0.3)
            [bottomHintStackView, cameraHintView, cameraView].showViews()
            [disclaimerItemsView, secondaryButton, selfieImageView].showViews(false)
            //startCaptureSession() //TODO: do video stuff
        case .previewSelfieVideo:
            //startCaptureSession(false) //TODO: do video stuff
            [bottomHintStackView, cameraHintView, cameraView].showViews(false)
            [disclaimerItemsView, secondaryButton, selfieImageView].showViews()
        }
    }
    
    private func didTapPrimaryButton() {
        switch viewState {
        case .capture:
            capturePhoto()
        case .previewSelfie:
            viewModel.analyseImage()
        case .record:
            break //TODO: do video recording
        case .previewSelfieVideo:
            break //TODO: do video analysis
        }
    }
    
    private func didTapSecondaryButton() {
        updateViewState()
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
        cameraHintView.showView(!start)
        runOnBackgroundThread { [weak self] in
            start ? self?.captureSession.startRunning() : self?.captureSession.stopRunning()
        }
    }
    
    override func showLoader(_ show: Bool) {
        [primaryButton, secondaryButton].enable(!show)
        with(cameraHintView) {
            $0.showView(show)
            $0.backgroundColor = show ? .primary : .black
            $0.textLabel.text = "Proccessing..."
        }
        if show {
            selfieImageBlurEffectView = selfieImageView.applyBlurEffect(alpha: 0.8)
        } else {
            selfieImageBlurEffectView?.removeFromSuperview()
            selfieImageBlurEffectView = nil
        }
    }

}

extension SelfieVideoKYCViewController: SelfieVideoKYCViewProtocol {
    func showSelfieImageError(message: String) {
        runOnMainThread { [weak self] in
            guard let self else { return }
            with(self.cameraHintView) {
                $0.showView()
                $0.backgroundColor = .red
                $0.textLabel.text = message
            }
            [self.primaryButton, self.secondaryButton].enable()
            
            runAfter(2) {
                self.showLoader(false)
            }
        }
    }
}

extension SelfieVideoKYCViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let uiImage = UIImage(data: imageData) {
            viewModel.imageData = imageData
            didCaptureImage(uiImage)
        } else {
            kprint("Error capturing photo: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    private func didCaptureImage(_ uiImage: UIImage) {
        runOnMainThread { [weak self] in
            self?.updateViewState()
            self?.selfieImageView.image = uiImage
        }
    }
}
