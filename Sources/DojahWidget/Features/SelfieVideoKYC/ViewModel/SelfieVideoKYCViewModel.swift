//
//  SelfieVideoKYCViewModel.swift
//
//
//  Created by Isaac Iniongun on 31/10/2023.
//

import Foundation

final class SelfieVideoKYCViewModel: BaseViewModel {
    
    private enum Constants {
        static let imageAnalysisMaxTries = 3
        static let imageCheckMaxTries = 2
    }
    
    weak var viewProtocol: SelfieVideoKYCViewProtocol?
    private let remoteDatasource: LivenessRemoteDatasourceProtocol
    let verificationMethod: GovtIDVerificationMethod
    var imageData: Data?
    private var imageAnalysisTries = 0
    private var imageCheckMaxTries = 0
    
    init(
        remoteDatasource: LivenessRemoteDatasourceProtocol = LivenessRemoteDatasource(),
        verificationMethod: GovtIDVerificationMethod = .selfie
    ) {
        self.remoteDatasource = remoteDatasource
        self.verificationMethod = verificationMethod
        super.init()
    }
    
    func analyseImage() {
        guard let imageData else { return }
        showLoader?(true)
        let params = [
            "image": imageData.base64EncodedString(),
            "image_type": "selfie"
        ]
        imageAnalysisTries += 1
        remoteDatasource.performImageAnalysis(params: params) { [weak self] result in
            switch result {
            case let .success(response):
                self?.didGetImageAnalysisResponse(response)
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
    private func didGetImageAnalysisResponse(_ response: EntityResponse<ImageAnalysisResponse>) {
        guard [.governmentDataVerification, .governmentData].contains(preference.DJAuthStep.name),
              let analysisResponse = response.entity else {
            showLoader?(false)
            showToast(message: DJConstants.genericErrorMessage, type: .error)
            return
        }
        
        if analysisResponse.face?.faceDetected == false {
            showLoader?(false)
            viewProtocol?.showSelfieImageError(message: "No face detected")
            return
        }
        
        if analysisResponse.face?.multifaceDetected == true {
            showLoader?(false)
            viewProtocol?.showSelfieImageError(message: "Multiple faces detected")
            return
        }
        
        if analysisResponse.face?.quality?.brightness ?? 0 <= preference.DJAuthStep.config.brightnessThreshold ?? 40 {
            showLoader?(false)
            viewProtocol?.showSelfieImageError(message: "Not bright enough. Please move to a brighter area")
            return
        }
        
        if preference.DJAuthStep.config.glassesCheck ?? true != 
            (analysisResponse.face?.details?.eyeglasses?.value ?? false || analysisResponse.face?.details?.sunglasses?.value ?? false) {
            showLoader?(false)
            viewProtocol?.showSelfieImageError(message: "Glasses detected. Retake selfie without your glasses")
            return
        }
        
        performImageCheck()
        
        /*if analysisResponse.face?.faceDetected == true &&
            analysisResponse.face?.multifaceDetected == false &&
            analysisResponse.face?.quality?.brightness ?? 0 >= preference.DJAuthStep.config.brightnessThreshold ?? 40 &&
            preference.DJAuthStep.config.glassesCheck ?? true == (analysisResponse.face?.details?.eyeglasses?.value ?? false || analysisResponse.face?.details?.sunglasses?.value ?? false)
        {
            performImageCheck()
        } else {
            showLoader?(false)
        }*/
    }
    
    private func performImageCheck() {
        imageCheckMaxTries += 1
        guard let imageData else { return }
        let params: DJParameters = [
            "image": imageData.base64EncodedString(),
            "param": "face",
            "selfie_type": "single",
            "doc_type": "image",
            "continue_verification": imageAnalysisTries >= Constants.imageAnalysisMaxTries
        ]
        remoteDatasource.performImageCheck(params: params) { [weak self] result in
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
                request: .event(name: .stepFailed, pageName: .governmentDataVerification),
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
            faceVerificationDidSucceed()
        } else {
            showLoader?(false)
            if imageCheckMaxTries > Constants.imageCheckMaxTries {
                postEvent(
                    request: .event(name: .stepFailed, pageName: .governmentDataVerification),
                    showLoader: false,
                    showError: false
                )
                // call /decision endpoint or go to the next step
            }
            //Placeholder code
            showErrorMessage("Liveness verification failed")
        }
    }
    
    private func faceVerificationDidSucceed() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: .governmentDataVerification),
            showLoader: false,
            showError: false
        )
        
        remoteDatasource.verifyImage(params: [:]) { [weak self] result in
            switch result {
            case .success(_):
                self?.showLoader?(false)
                self?.showMessage?(.success(message: "Liveness check successful"))
            case let .failure(error):
                self?.showErrorMessage(error.localizedDescription)
            }
        }
    }
    
}
