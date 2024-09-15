//
//  AttachmentManager.swift
//
//
//  Created by Isaac Iniongun on 29/10/2023.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

/*  USAGE
 
 AttachmentManager.shared.showOptions(on: self)
 AttachmentManager.shared.imagePickedHandler = { (image) in
 /* get your image here */
 }
 AttachmentManager.shared.videoPickedHandler = {(url) in
 /* get your compressed video url here */
 }
 AttachmentManager.shared.filePickedHandler = {(filePath) in
 /* get your file path url here */
 }
 */

final class AttachmentManager: NSObject {
    static let shared = AttachmentManager()
    fileprivate var viewController: UIViewController?
    
    fileprivate override init(){}
    
    //MARK: - Internal Properties
    var imagePickedHandler: ((UIImage, URL?, UIImagePickerController.SourceType) -> Void)?
    var videoPickedHandler: ((NSURL) -> Void)?
    var filePickedHandler: ((URL) -> Void)?
    var dismissHandler: NoParamHandler?
    
    enum AttachmentType: String {
        case camera = "Camera", video = "Video", photoLibrary = "Photo Library", files = "Files"
        
        var alertTitle: String {
            "Dojah Widget SDK does not have access to your \(rawValue). Enable access in your Settings app."
        }
    }
    
    var hasCameraPermission: Bool {
        AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    func checkCameraPermission(success: (() -> Void)? = nil, error: (() -> Void)? = nil) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            success?()
        case .notDetermined:
            requestCameraPermission(success: success, error: error)
        case .denied, .restricted:
            Toast.shared.show("Camera permission is required", type: .error)
            error?()
        @unknown default:
            break
        }
    }

    func requestCameraPermission(success: (() -> Void)? = nil, error: (() -> Void)? = nil) {
        guard !hasCameraPermission else {
            success?()
            return
        }
        AVCaptureDevice.requestAccess(for: .video) { granted in
            runOnMainThread {
                if granted {
                    success?()
                } else {
                    Toast.shared.show("Camera permission denied", type: .error)
                    error?()
                }
            }
        }
    }
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showOptions(
        on vc: UIViewController,
        attachmentTypes: [AttachmentType] = [.camera, .photoLibrary],
        docTypes: [String]? = nil
    ) {
        viewController = vc
        let actionSheet = UIAlertController(
            title: "Add a File",
            message: "Choose a filetype to add...",
            preferredStyle: .actionSheet
        )
        
        attachmentTypes.forEach { attachmentType in
            switch attachmentType {
            case .camera, .video, .photoLibrary:
                let alertAction = UIAlertAction(
                    title: attachmentType.rawValue,
                    style: .default,
                    handler: { _ in
                        self.authorisationStatus(for: attachmentType, vc: self.viewController!)
                    }
                )
                actionSheet.addAction(alertAction)
            case .files:
                let alertAction = UIAlertAction(
                    title: attachmentType.rawValue,
                    style: .default,
                    handler: { (action) -> Void in
                        self.openDocumentPicker(on: vc, docTypes: docTypes)
                    }
                )
                actionSheet.addAction(alertAction)
            }
            
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] action in
            self?.dismissHandler?()
        }))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(for attachmentType: AttachmentType, vc: UIViewController) {
        viewController = vc
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            didAuthorize()
        case .denied:
            self.showSettingsAlert(attachmentType)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == PHAuthorizationStatus.authorized {
                    didAuthorize()
                } else {
                    runOnMainThread {
                        self.showSettingsAlert(attachmentType)
                    }
                }
            }
        case .restricted:
            self.showSettingsAlert(attachmentType)
        default:
            break
        }
        
        func didAuthorize() {
            runOnMainThread { [weak self] in
                switch attachmentType {
                case .camera:
                    self?.openCamera(on: vc)
                case .video:
                    self?.openVideoLibrary(on: vc)
                case .photoLibrary:
                    self?.openPhotoLibrary(on: vc)
                case .files:
                    break
                }
            }
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(on vc: UIViewController, device: UIImagePickerController.CameraDevice = .rear) {
        viewController = vc
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            pickerController.cameraDevice = device
            viewController?.present(pickerController, animated: true, completion: nil)
        } else {
            Toast.shared.show("Your device doesn't have camera capabilties", type: .error)
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func openPhotoLibrary(on vc: UIViewController) {
        viewController = vc
        runOnMainThread { [weak self] in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self?.viewController?.present(myPickerController, animated: true, completion: nil)
            } else {
                Toast.shared.show("Your device doesn't have file picking capabilties", type: .error)
            }
        }
    }
    
    //MARK: - VIDEO PICKER
    func openVideoLibrary(on vc: UIViewController) {
        viewController = vc
        runOnMainThread { [weak self] in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                self?.viewController?.present(myPickerController, animated: true, completion: nil)
            } else {
                showToast(message: "Your device doesn't have video picking capabilties", type: .error)
            }
        }
    }
    
    //MARK: - FILE PICKER
    func openDocumentPicker(on vc: UIViewController, docTypes: [String]? = nil) {
        viewController = vc
        let docTypes = docTypes ?? [
            String(kUTTypePDF),
            String(kUTTypeMP3),
            String(kUTTypePNG),
            String(kUTTypeJPEG),
            String(kUTTypeAudio),
            String(kUTTypeImage),
            String(kUTTypeMovie),
            String(kUTTypeText),
            String(kUTTypeContent),
            String(kUTTypeItem),
            String(kUTTypeData)
        ]
        
        runOnMainThread { [weak self] in
            let documentPicker = UIDocumentPickerViewController(documentTypes: docTypes, in: .import)
            documentPicker.delegate = self
            self?.viewController?.present(documentPicker, animated: true)
        }
    }
    
    //MARK: - SETTINGS ALERT
    func showSettingsAlert(_ attachmentType: AttachmentType) {
        let alertController = UIAlertController (
            title: attachmentType.alertTitle,
            message: nil, 
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { _ in
            openSettingsApp()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        viewController?.present(alertController , animated: true, completion: nil)
    }
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController?.dismiss(animated: true, completion: nil)
        dismissHandler?()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedHandler?(image, info[UIImagePickerController.InfoKey.imageURL] as? URL, picker.sourceType)
        } else {
            print("Something went wrong in  image")
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL {
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            compressWithSessionStatusFunc(videoUrl)
        } else {
            print("Something went wrong in  video")
        }
        
        viewController?.dismiss(animated: true, completion: nil)
        dismissHandler?()
    }
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }
            
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
                
                DispatchQueue.main.async {
                    self.videoPickedHandler?(compressedURL as NSURL)
                }
                
            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset1280x720) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

extension AttachmentManager: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        self.filePickedHandler?(urls[0])
    }
}
