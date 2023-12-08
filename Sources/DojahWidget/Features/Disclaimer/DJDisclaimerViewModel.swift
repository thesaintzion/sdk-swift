//
//  DJDisclaimerViewModel.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

final class DJDisclaimerViewModel: BaseViewModel {
    var canSeeCountryPage: Bool {
        preference.DJCanSeeCountryPage
    }
    
    func postStepCompletedEvent() {
        //let vp = viewProtocol as? DJDisclaimerViewProtocol
        
        postEvent(request: .init(name: .stepCompleted, value: "index", stepNumber: 0))
    }
    
    override func postEventDidSucceed(_ eventsResponse: DJEventResponse) {
        kprint("Posted index completed event")
    }
    
    override func postEventDidFail(_ error: Error) {
        kprint("couldn't post index event")
    }
    
}
