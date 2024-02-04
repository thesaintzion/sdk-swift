//
//  GovtIDCaptureViewModel.swift
//
//
//  Created by Isaac Iniongun on 01/02/2024.
//

import Foundation

final class GovtIDCaptureViewModel: BaseViewModel {
    
    private enum Constants {
        static let imageAnalysisMaxTries = 3
        static let imageCheckMaxTries = 2
    }
    
    let selectedID: DJGovernmentID
    private let livenessRemoteDatasource: LivenessRemoteDatasourceProtocol
    weak var viewProtocol: GovtIDCaptureViewProtocol?
    var viewState: GovtIDCaptureViewState = .captureFront
    var idFrontImageData: Data?
    var idBackImageData: Data?
    private var imageAnalysisTries = 0
    private var imageCheckMaxTries = 0
    private var isFrontAndBackID: Bool {
        selectedID.idType?.isFrontAndBack ?? false
    }
    private var pageName: DJPageName {
        preference.DJAuthStep.name
    }
    private var isBusinessID: Bool {
        pageName == .businessID
    }
    private var imageCheckParam: String {
        isBusinessID ? "BUSINESS" : selectedID.idType?.rawValue ?? "ID"
    }
    var idName: String {
        isBusinessID ? "CAC Document" : selectedID.name ?? ""
    }
    
    init(
        selectedID: DJGovernmentID = .empty,
        livenessRemoteDatasource: LivenessRemoteDatasourceProtocol = LivenessRemoteDatasource()
    ) {
        self.selectedID = selectedID
        self.livenessRemoteDatasource = livenessRemoteDatasource
        super.init()
        initViewState()
    }
    
    private func initViewState() {
        switch preference.DJAuthStep.name {
        case .id:
            viewState = .captureFront
        case .businessID:
            viewState = .captureCACDocument
        case .additionalDocument:
            break
        default:
            break
        }
    }
    
    func didTapContinue() {
        switch viewState {
        case .captureFront:
            break
        case .captureBack:
            break
        case .previewFront, .uploadFront, .previewCACDocument:
            guard let idFrontImageData else {
                showToast(message: "Capture or choose a valid image", type: .error)
                return
            }
            analyseImage(idFrontImageData)
        case .previewBack, .uploadBack:
            guard let idBackImageData else {
                showToast(message: "Capture or choose a valid image", type: .error)
                return
            }
            analyseImage(idBackImageData)
        case .captureCACDocument:
            break
        case .uploadCACDocument:
            break
        }
    }
    
    func updateImageData(_ data: Data) {
        if isFrontAndBackID {
            if viewState == .captureFront {
                idFrontImageData = data
            } else {
                idBackImageData = data
            }
        } else {
            idFrontImageData = data
        }
    }
    
    func updateIDData(from fileURL: URL) {
        let data = fileURL.dataRepresentation
        if isFrontAndBackID {
            if viewState == .uploadFront {
                idFrontImageData = data
            } else {
                idBackImageData = data
            }
        } else {
            idFrontImageData = data
        }
    }
    
    private func analyseImage(_ imageData: Data) {
        if imageAnalysisTries >= Constants.imageAnalysisMaxTries {
            postEvent(
                request: .event(name: .stepFailed, pageName: pageName),
                didSucceed: { [weak self] _ in
                    self?.showErrorMessage("No ID Detected & Max tries exceeded")
                },
                didFail: { [weak self] _ in
                    self?.showErrorMessage("No ID Detected & Max tries exceeded")
                }
            )
            return
        }
        showLoader?(true)
        let params = [
            "image": imageData.base64EncodedString(),
            "image_type": "id" //pass 'id' for government-issued-id
        ]
        imageAnalysisTries += 1
        livenessRemoteDatasource.performImageAnalysis(params: params) { [weak self] result in
            self?.showLoader?(false)
            switch result {
            case let .success(response):
                self?.didGetImageAnalysisResponse(response)
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    private func didGetImageAnalysisResponse(_ response: EntityResponse<ImageAnalysisResponse>) {
        //guard let idType = selectedID.idType else { return }
        
        if (selectedID.idType?.isNGNIN == true) || isBusinessID {
            performImageCheck()
            return
        }
        
        guard response.entity?.id?.details?.idCards != nil ||
              response.entity?.id?.details?.passport != nil
        else {
            runOnMainThread { [weak self] in
                guard let self else { return }
                if [.uploadFront, .uploadBack].contains(self.viewState) {
                    showToast(message: "No ID detected", type: .error)
                } else {
                    self.viewProtocol?.showIDImageError(message: "No ID detected")
                }
            }
            return
        }
        if isFrontAndBackID {
            updateViewState()
        } else {
            performImageCheck()
        }
    }
    
    func updateViewState() {
        switch viewState {
        case .uploadFront:
            imageAnalysisTries = 0
            viewState = .uploadBack
        case .uploadBack:
            imageAnalysisTries = 0
            // call /check here
        case .captureFront:
            viewState = .previewFront
        case .captureBack:
            viewState = .previewBack
        case .previewFront:
            imageAnalysisTries = 0
            viewState = .captureBack
        case .previewBack:
            imageAnalysisTries = 0
            //call /check here
        case .captureCACDocument:
            viewState = .previewCACDocument
        case .uploadCACDocument:
            break
        case .previewCACDocument:
            break
        }
        runOnMainThread { [weak self] in
            self?.viewProtocol?.updateUI()
        }
    }
    
    private func performImageCheck() {
        imageCheckMaxTries += 1
        guard let idFrontImageData else { return } //let idType = selectedID.idType,
        var params: DJParameters = [
            "image": idFrontImageData.base64EncodedString(),
            "param": imageCheckParam, // pass 'NG{country alpha2 code}-PASS' when using passport. this is gotten from the selected id from the identification map
            // pass 'BUSINESS' for business ID
            "selfie_type": "single",
            "doc_type": "image",
            "continue_verification": imageAnalysisTries >= Constants.imageAnalysisMaxTries
        ]
        if isFrontAndBackID, let idBackImageData {
            params["image2"] = idBackImageData.base64EncodedString()
        }
        
        livenessRemoteDatasource.performImageCheck(params: params) { [weak self] result in
            switch result {
            case let .success(response):
                self?.didGetImageCheckResponse(response)
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    private func didGetImageCheckResponse(_ response: EntityResponse<ImageCheckResponse>) {
        if imageAnalysisTries >= Constants.imageAnalysisMaxTries {
            postEvent(
                request: .event(name: .stepFailed, pageName: pageName),
                showLoader: false,
                showError: false
            )
        }
        
        guard let checkResponse = response.entity else {
            showLoader?(false)
            showToast(message: DJConstants.genericErrorMessage, type: .error)
            return
        }
        
        if checkResponse.match ?? false {
            imageCheckDidSucceed()
        } else {
            showLoader?(false)
            if imageCheckMaxTries > Constants.imageCheckMaxTries {
                postEvent(
                    request: .event(name: .stepFailed, pageName: pageName),
                    showLoader: false,
                    showError: false
                )
                setNextAuthStep()
                // call /decision endpoint or go to the next step
            }
            showErrorMessage(checkResponse.reason ?? "\(idName) verification failed")
        }
    }
    
    private func imageCheckDidSucceed() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: pageName),
            showLoader: false,
            showError: false
        )
        
        livenessRemoteDatasource.verifyImage(params: [:]) { [weak self] result in
            switch result {
            case .success(_):
                self?.showLoader?(false)
                self?.setNextAuthStep()
                //self?.showMessage?(.success(message: "ID check successful"))
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
}
