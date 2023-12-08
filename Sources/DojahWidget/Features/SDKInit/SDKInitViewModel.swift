//
//  SDKInitViewModel.swift
//
//
//  Created by Isaac Iniongun on 01/12/2023.
//

import Foundation
import UIKit
import WebKit

final class SDKInitViewModel {
    
    weak var viewProtocol: SDKInitViewProtocol?
    private let widgetID: String
    private var preference: PreferenceProtocol
    private let countriesDatasource: CountriesLocalDatasourceProtocol
    private let authenticationRemoteDatasource: AuthenticationRemoteDatasourceProtocol
    private var authResponse: DJAuthResponse?
    private var preAuthRes: DJPreAuthResponse?
    
    init(
        widgetID: String,
        preference: PreferenceProtocol = PreferenceImpl(),
        countriesDatasource: CountriesLocalDatasourceProtocol = CountriesLocalDatasource(),
        authenticationRemoteDatasource: AuthenticationRemoteDatasourceProtocol = AuthenticationRemoteDatasource()
    ) {
        self.widgetID = widgetID
        self.preference = preference
        self.preference.DJWidgetID = widgetID
        self.countriesDatasource = countriesDatasource
        self.authenticationRemoteDatasource = authenticationRemoteDatasource
    }
    
    func initialize() {
        viewProtocol?.showLoader(true)
        getUserAgent()
        
        guard !preference.DJCountriesInitialized else {
            preAuthenticate()
            return
        }
        
        guard let jsonData = jsonData(from: "countries") else {
            initializationDidFail()
            return
        }
        
        do {
            let countries = try jsonData.decode(into: [DJCountry].self)
            let dbCountries = countries.map { $0.countryDB }
            try countriesDatasource.saveCountries(dbCountries)
            preference.DJCountriesInitialized = true
            preAuthenticate()
        } catch {
            initializationDidFail(error: error)
        }
    }
    
    private func initializationDidFail(error: Error? = nil) {
        if let error {
            kprint("\(error)")
        }
        viewProtocol?.showLoader(false)
        viewProtocol?.showSDKInitFailedView()
    }
    
    private func preAuthenticate() {
        let params = ["widget_id": widgetID]
        authenticationRemoteDatasource.getPreAuthenticationInfo(params: params) { [weak self] result in
            switch result {
            case let .success(preAuthRes):
                self?.didGetPreAuthenticationResponse(preAuthRes)
            case .failure(let error):
                self?.initializationDidFail(error: error)
            }
        }
    }
    
    private func didGetPreAuthenticationResponse(_ preAuthRes: DJPreAuthResponse) {
        guard preAuthRes.widget?.pages?.isNotEmpty ?? false else {
            initializationDidFail()
            return
        }
        self.preAuthRes = preAuthRes
        if let appConfig = preAuthRes.appConfig {
            preference.DJAppConfig = appConfig
        }
        preference.DJCanSeeCountryPage = preAuthRes.widget?.countries?.isNotEmpty ?? false
        authenticate(using: preAuthRes)
    }
    
    private func authenticate(using preAuthRes: DJPreAuthResponse) {
        let params: DJParameters = [
            "app_id": preAuthRes.appConfig?.id ?? "",
            "public_key": preAuthRes.publicKey.orEmpty,
            "type": "kyc",
            "review_process": preAuthRes.widget?.reviewProcess ?? "Automatic",
            "steps": createStepsParameters()
        ]
        
        authenticationRemoteDatasource.authenticate(params: params) { [weak self] result in
            switch result {
            case let .success(authResponse):
                self?.didGetAuthenticationResponse(authResponse: authResponse)
            case let .failure(error):
                self?.initializationDidFail(error: error)
            }
        }
    }
    
    private func didGetAuthenticationResponse(authResponse: DJAuthResponse) {
        guard authResponse.initData.isNotNil else {
            initializationDidFail()
            return
        }
        self.authResponse = authResponse
        guard let preAuthRes else { return }
        preference.DJRequestHeaders = [
            "authorization": UUID().uuidString,
            "app-id": preAuthRes.appConfig?.id ?? authResponse.appConfig?.id ?? "",
            "p-key": preAuthRes.publicKey.orEmpty,
            "session": authResponse.sessionID.orEmpty,
            "reference": authResponse.initData?.data?.referenceID ?? ""
        ]
        preference.DJVerificationID = authResponse.initData?.data?.verificationID ?? 0
        getIPAddress()
    }
    
    private func createStepsParameters() -> [DJParameters] {
        guard let preAuthRes else { return [] }
        var steps = [DJAuthStep]()
        var currentID = 0
        steps.append(.init(name: .index, id: 0, config: .init()))
        
        if (preAuthRes.widget?.countries ?? []).countGreaterThan(1) {
            currentID += 1
            steps.append(.init(name: .countries, id: currentID, config: .init(configDefault: "")))
        }
        
        let govtDataPage = preAuthRes.widget?.pages?.first(where: { $0.pageName == .governmentData })
        if let govtDataPage {
            currentID += 1
            steps.append(.init(name: .governmentData, id: currentID, config: govtDataPage.config ?? .init()))
            let verifications = [govtDataPage.config?.otp ?? false, govtDataPage.config?.selfie ?? false]
            if verifications.contains(true) {
                currentID += 1
                steps.append(.init(name: .governmentDataVerification, id: currentID, config: govtDataPage.config ?? .init()))
            }
        }
        
        let idPage = preAuthRes.widget?.pages?.first(where: { $0.pageName == .id })
        if let idPage {
            currentID += 1
            steps.append(.init(name: .idOptions, id: currentID, config: .init()))
            currentID += 1
            steps.append(.init(name: .id, id: currentID, config: idPage.config ?? .init()))
        }
        
        let pages = preAuthRes.widget?.pages?.filter { $0.pageName != .governmentData && $0.pageName != .id }
        if let pages {
            for page in pages {
                if let pageName = page.pageName {
                    currentID += 1
                    steps.append(.init(name: pageName, id: currentID, config: page.config ?? .init()))
                }
            }
        }
        
        kprint(String(describing: steps.dictionaryArray))
        
        return steps.map { $0.dictionary }
    }
    
    private func getIPAddress() {
        authenticationRemoteDatasource.getIPAddress { [weak self] result in
            switch result {
            case let .success(ipAddress):
                self?.saveIPAddress(ipAddress)
            case let .failure(error):
                self?.initializationDidFail(error: error)
            }
        }
    }
    
    private func saveIPAddress(_ ipAddress: DJIPAddress) {
        guard ipAddress.ip != "" else {
            initializationDidFail()
            return
        }
        let parameters: DJParameters = [
            "ip": ipAddress.ip.orEmpty,
            "device_info": preference.DJUserAgent
        ]
        authenticationRemoteDatasource.saveIPAddress(params: parameters) { [weak self] result in
            switch result {
            case let .success(ipAddressResponse):
                self?.didSaveIPAddress(response: ipAddressResponse)
            case let .failure(error):
                self?.initializationDidFail(error: error)
            }
        }
    }
    
    private func didSaveIPAddress(response: DJIPAddressResponse) {
        guard let country = response.entity?.country, country.isNotEmpty else {
            initializationDidFail()
            return
        }
        preference.DJIPCountry = country
        runOnMainThread { [weak self] in
            self?.viewProtocol?.showDisclaimer()
        }
    }
    
    private func getUserAgent() {
        guard preference.DJUserAgent.isEmpty else { return }
        if let userAgent = WKWebView().value(forKey: "userAgent") as? String {
            kprint("UserAgent: \(userAgent)")
            preference.DJUserAgent = userAgent
        } else {
            kprint("Unable to get UserAgent")
        }
    }
}
