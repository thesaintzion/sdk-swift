//
//  AddressVerificationViewModel.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation
import GooglePlaces
import CoreLocation

final class AddressVerificationViewModel: BaseViewModel {
    private let remoteDatasource: AddressVerificationRemoteDatasourceProtocol
    weak var viewProtocol: AddressVerificationViewProtocol?
    var selectedPlace: GMSPlace?
    var currentLocation: CLLocation?
    private lazy var autocompleteSessionToken = GMSAutocompleteSessionToken()
    private lazy var placesClient = GMSPlacesClient.shared()
    var placePredictions = [GMSAutocompletePrediction]()
    
    init(remoteDatasource: AddressVerificationRemoteDatasourceProtocol = AddressVerificationRemoteDatasource()) {
        self.remoteDatasource = remoteDatasource
        super.init()
    }
    
    func didTapContinue() {
        hideMessage()
        guard let selectedPlace else {
            showErrorMessage("Choose a valid address")
            return
        }
        
        showLoader?(true)
        
        let params: DJParameters = [
            "latitude": selectedPlace.coordinate.latitude,
            "longitude": selectedPlace.coordinate.longitude,
            "name": selectedPlace.formattedAddress ?? ""
        ]
        
        remoteDatasource.sendAddress(type: .userSelected, params: params) { [weak self] result in
            switch result {
            case let .success(response):
                self?.didSendUserSelectedAddress(response)
            case let .failure(error):
                self?.showLoader?(false)
                self?.postStepEvent(name: .stepFailed)
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func didSendUserSelectedAddress(_ response: SuccessEntityResponse) {
        guard response.entity?.success == true else {
            postStepEvent(name: .stepFailed)
            showErrorMessage(response.entity?.msg ?? "Unable to submit address, please try again.")
            return
        }
        
        guard preference.DJAuthStep.config?.verification == true else {
            runAfter { [weak self] in
                self?.setNextAuthStep()
            }
            return
        }
        
        guard let selectedPlace, let currentLocation else {
            showErrorMessage("Unable to determine user's current location, please check your device settings and try again")
            return
        }
        
        // we want to check if the device coordinates and the coordinates of the address
        // the user selected on google places are within 50meters of each other and set
        // the value of 'match' based on that
        let distanceInMeters = currentLocation.distance(from: selectedPlace.coordinate.location)
        let match = distanceInMeters <= 50
        kprint("Distance(in meters) between Current Location(\(currentLocation.latLngString)) & Selected Location(\(selectedPlace.coordinate.latLngString)) => \(distanceInMeters)")
        let params: DJParameters = [
            "latitude": currentLocation.coordinate.latitude,
            "longitude": currentLocation.coordinate.longitude,
            "match": match
        ]
        
        remoteDatasource.sendAddress(type: .userLocation, params: params) { [weak self] result in
            self?.showLoader?(false)
            switch result {
            case let .success(response):
                self?.didSendCurrentLocationAddress(response)
            case let .failure(error):
                self?.postStepEvent(name: .stepFailed)
                self?.showErrorMessage(error.uiMessage)
            }
        }
    }
    
    private func didSendCurrentLocationAddress(_ response: SuccessEntityResponse) {
        guard response.entity?.success == true else {
            postStepEvent(name: .stepFailed)
            showErrorMessage(response.entity?.msg ?? "Unable to submit user's current location, please try again.")
            return
        }
        postStepEvent(name: .stepCompleted)
        runAfter { [weak self] in
            self?.setNextAuthStep()
        }
    }
    
    private func postStepEvent(name: DJEventName) {
        hideMessage()
        postEvent(
            request: .event(name: name, pageName: .address), 
            showLoader: false,
            showError: false
        )
    }
    
    func findAddress(_ text: String) {
        placesClient.findAutocompletePredictions(
            fromQuery: text,
            filter: nil,
            sessionToken: autocompleteSessionToken
        ) { [weak self] results, error in
            
            if let error = error {
                kprint("Autocomplete findAutocompletePredictions error: \(error)")
            }
            
            if let results, results.isNotEmpty {
                self?.placePredictions = results
                kprint("Prediction Results")
                kprint("\(results.map { $0.attributedFullText.string })")
                runOnMainThread {
                    self?.viewProtocol?.showPlacesResults()
                }
            }
        }
    }
    
    func didChoosePlacePrediction(_ prediction: GMSAutocompletePrediction) {
        placesClient.fetchPlace(
            fromPlaceID: prediction.placeID,
            placeFields: .all,
            sessionToken: autocompleteSessionToken
        ) { [weak self] gmsPlace, error in
            if let error = error {
                kprint("Autocomplete fetchPlace error: \(error)")
                self?.enableContinueButton(false)
            }
            
            if let gmsPlace {
                kprint("Autocomplete fetchPlace success: PlaceID: \(gmsPlace.placeID.orEmpty)")
                self?.selectedPlace = gmsPlace
                self?.enableContinueButton()
            }
        }
    }
    
    private func enableContinueButton(_ enable: Bool = true) {
        runOnMainThread { [weak self] in
            self?.viewProtocol?.enableContinueButton(enable)
        }
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
