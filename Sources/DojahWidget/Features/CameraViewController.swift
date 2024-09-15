//
//  CameraViewController.swift
//
//
//  Created by Isaac Iniongun on 27/01/2024.
//

import UIKit
import AVFoundation

public class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    private var previewLayer: AVCaptureVideoPreviewLayer?
    private lazy var captureButton = DJButton(title: "Capture") { [weak self] in
        self?.takePhotoButtonTapped()
    }
    let cameraView = UIView(size: 200, backgroundColor: .clear, radius: 100, clipsToBounds: true)
    let cameraBorderView = UIView(size: 250, backgroundColor: .clear, radius: 125, clipsToBounds: true)
    let containerView = UIView(size: 300, backgroundColor: .clear, radius: 150, clipsToBounds: true)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUserInterfaceStyle()
        backgroundColor = .aSystemBackground
        addSubviews(containerView, cameraBorderView, cameraView)
        containerView.centerXInSuperview()
        containerView.anchor(top: safeAreaTopAnchor, padding: .kinit(top: 50))
        cameraBorderView.centerIn(containerView)
        cameraView.centerIn(containerView)
        runAfter { [weak self] in
            self?.setupCamera()
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBorders()
    }
    
    private func setBorders() {
        [containerView, cameraView, cameraBorderView].forEach {
            setDashedBorder(
                on: $0,
                dashLength: 4,
                dashSpacing: 8,
                lineWidth: 20,
                lineDashPhase: 4,
                strokeColor: .primary
            )
        }
    }
    
    private func setupOnionRings() {
        var ringRadius: CGFloat = 70
        let numberOfRings = 3
        
        for _ in 0..<numberOfRings {
            let circularView = UIView(frame: CGRect(x: 0, y: 0, width: ringRadius * 2, height: ringRadius * 2))
            circularView.center = view.center
            circularView.layer.cornerRadius = ringRadius
            circularView.clipsToBounds = true
            view.addSubview(circularView)
            
            setDashedBorder(
                on: circularView,
                dashLength: 4,
                dashSpacing: 8,
                lineWidth: 20,
                lineDashPhase: 4,
                strokeColor: .primary
            )
            
            ringRadius += 40
        }
    }
    
    private func setDashedBorder(
        on uiview: UIView,
        dashLength: NSNumber,
        dashSpacing: NSNumber,
        lineWidth: CGFloat = 1,
        lineDashPhase: CGFloat = 0,
        strokeColor: UIColor = .black
    ) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = strokeColor.cgColor
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
    }
    
    private func setupCamera() {
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Front camera not available.")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)

            if captureSession.canAddInput(input) && captureSession.canAddOutput(photoOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(photoOutput)

                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = .resizeAspectFill
                //previewLayer?.frame = view.layer.bounds
                //view.layer.insertSublayer(previewLayer!, at: 0)
                guard let previewLayer else { return }
                previewLayer.frame = cameraView.layer.bounds
                cameraView.layer.insertSublayer(previewLayer, at: 0)
                
                runOnBackgroundThread { [weak self] in
                    self?.captureSession.startRunning()
                }
            }
        } catch {
            print("Error setting up camera input: \(error.localizedDescription)")
        }
    }

    private func takePhotoButtonTapped() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = .auto
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
            // Handle the captured image
            print("Photo captured successfully")
        } else {
            print("Error capturing photo: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
