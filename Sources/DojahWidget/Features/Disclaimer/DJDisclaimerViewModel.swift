//
//  DJDisclaimerViewModel.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

final class DJDisclaimerViewModel: BaseViewModel {
    weak var viewProtocol: DJDisclaimerViewProtocol?
    var canSeeCountryPage: Bool {
        preference.DJCanSeeCountryPage
    }
    
    func postStepCompletedEvent() {
        postEvent(request: .init(name: .stepCompleted, value: "index", stepNumber: 0))
    }
    
    override func postEventDidSucceed(_ eventsResponse: DJEventResponse) {
        setNextPageName(stepNumber: 1)
    }
    
    override func postEventDidFail(_ error: Error) {
        kprint("couldn't post index event")
    }
    
}
