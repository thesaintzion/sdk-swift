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
        case camera, video, photoLibrary, file
    }
    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        static let alertForPhotoLibraryMessage = "Dojah Widget SDK does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        static let alertForCameraAccessMessage = "Dojah Widget SDK does not have access to your camera. To enable access, tap settings and turn on Camera."
        static let alertForVideoLibraryMessage = "Dojah Widget SDK does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
    }
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showOptions(on vc: UIViewController, attachmentTypes: [AttachmentType] = [.camera, .photoLibrary]) {
        viewController = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        attachmentTypes.forEach {
            
            switch $0 {
            case .camera:
                actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
                    self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.viewController!)
                }))
            case .photoLibrary:
                actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
                    self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.viewController!)
                }))
            case .video:
                actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
                    self.authorisationStatus(attachmentTypeEnum: .video, vc: self.viewController!)
                }))
            case .file:
                actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
                    self.documentPicker()
                }))
            }
            
        }
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: { [weak self] action in
            self?.dismissHandler?()
        }))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController) {
        viewController = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            runOnMainThread { [weak self] in
                if attachmentTypeEnum == AttachmentType.camera {
                    self?.openCamera(on: vc)
                }
                if attachmentTypeEnum == AttachmentType.photoLibrary {
                    self?.openPhotoLibrary(on: vc)
                }
                if attachmentTypeEnum == AttachmentType.video {
                    self?.videoLibrary()
                }
            }
        case .denied:
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                runOnMainThread {
                    if status == PHAuthorizationStatus.authorized {
                        if attachmentTypeEnum == AttachmentType.camera {
                            self.openCamera(on: vc)
                        }
                        if attachmentTypeEnum == AttachmentType.photoLibrary {
                            self.openPhotoLibrary(on: vc)
                        }
                        if attachmentTypeEnum == AttachmentType.video {
                            self.videoLibrary()
                        }
                    } else {
                        self.addAlertForSettings(attachmentTypeEnum)
                    }
                }
            })
        case .restricted:
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(on vc: UIViewController) {
        viewController = vc
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            viewController?.present(myPickerController, animated: true, completion: nil)
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
    func videoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            viewController?.present(myPickerController, animated: true, completion: nil)
        } else {
            runOnMainThread {
                Toast.shared.show("Your device doesn't have video picking capabilties", type: .error)
            }
        }
    }
    
    //MARK: - FILE PICKER
    func documentPicker() {
        let docTypes = [
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
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: docTypes, in: .import)
        documentPicker.delegate = self
        viewController?.present(documentPicker, animated: true)
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType) {
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            openSettingsApp()
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController.addAction(cancelAction)
        cameraUnavailableAlertController.addAction(settingsAction)
        viewController?.present(cameraUnavailableAlertController , animated: true, completion: nil)
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
