//
//  BusinessDataViewModel.swift
//
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import Foundation

final class BusinessDataViewModel: BaseViewModel {
    weak var viewProtocol: BusinessDataViewProtocol?
    private let remoteDatasource: BusinessDataRemoteDatasourceProtocol
    var documentTypes = [DJGovernmentID]()
    var selectedDocument: DJGovernmentID?
    
    init(remoteDatasource: BusinessDataRemoteDatasourceProtocol = BusinessDataRemoteDatasource()) {
        self.remoteDatasource = remoteDatasource
        super.init()
        documentTypes = GovernmentIDFactory.getBusinessDocumentTypes(preference: preference)
    }
    
    func didChooseDocumentType(at index: Int) {
        hideMessage()
        selectedDocument = documentTypes[index]
        viewProtocol?.updateNumberTextfield()
    }
    
    func verifyBusiness(name: String, number: String) {
        hideMessage()
        guard let selectedDocument else {
            showErrorMessage("Choose a document type")
            return
        }
        
        let eventValue = "\(selectedDocument.idEnum.orEmpty),\(number)"
        postEvent(
            request: .init(name: .verificationTypeSelected, value: eventValue),
            showLoader: false,
            showError: false
        )
        
        guard let businessDataType = BusinessDataType(rawValue: selectedDocument.idEnum.orEmpty) else {
            showErrorMessage(DJConstants.genericErrorMessage)
            return
        }
        
        let params = [
            businessDataType.verificationRequestParam: number,
            "company_name": name
        ]
        
        showLoader?(true)
        remoteDatasource.verify(
            type: businessDataType,
            params: params
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.didGetVerificationResponse(response, businessDataType: businessDataType)
            case let .failure(error):
                self?.showLoader?(false)
                self?.postStepFailedEvent()
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func didGetVerificationResponse(_ response: EntityResponse<BusinessDataResponse>, businessDataType: BusinessDataType) {
        hideMessage()
        guard let businessDataResponse = response.entity else {
            postStepFailedEvent()
            showErrorMessage(DJSDKError.invalidIDNotFoundBusinessData(businessDataType).uiMessage)
            return
        }
        let values = [businessDataResponse.business, businessDataType.rawValue, preference.DJCountryCode, businessDataResponse.companyName]
        let eventValue = values.compactMap { $0 }.joined(separator: ",")
        postEvent(
            request: .init(name: .customerBusinessDataCollected, value: eventValue),
            showLoader: false,
            showError: false,
            didSucceed: { [weak self] _ in
                self?.showLoader?(false)
                self?.postStepCompletedEvent()
                runAfter { [weak self] in
                    self?.setNextAuthStep()
                }
            },
            didFail: { [weak self] _ in
                self?.showLoader?(false)
                self?.postStepFailedEvent()
                runAfter { [weak self] in
                    self?.setNextAuthStep()
                }
            }
        )
    }
    
    private func postStepCompletedEvent() {
        postEvent(
            request: .event(name: .stepCompleted, pageName: .businessData),
            showLoader: false,
            showError: false
        )
    }
    
    private func postStepFailedEvent() {
        postEvent(
            request: .stepFailed(errorCode: .invalidIDNotFound),
            showLoader: false,
            showError: false
        )
    }
    
    private func hideMessage() {
        runOnMainThread { [weak self] in
            self?.viewProtocol?.hideMessage()
        }
    }
    
    private func showErrorMessage(_ message: String) {
        showLoader?(false)
        runOnMainThread { [weak self] in
            self?.viewProtocol?.showErrorMessage(message)
        }
    }
}
