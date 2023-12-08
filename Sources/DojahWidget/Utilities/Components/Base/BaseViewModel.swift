//
//  BaseViewModel.swift
//
//
//  Created by Isaac Iniongun on 08/12/2023.
//

import Foundation

class BaseViewModel {
    let eventsRemoteDatasource: EventsRemoteDatasourceProtocol
    var preference: PreferenceProtocol
    var showLoader: ParamHandler<Bool>?
    var showMessage: ParamHandler<FeedbackConfig>?
    
    init(
        eventsRemoteDatasource: EventsRemoteDatasourceProtocol = EventsRemoteDatasource(),
        preference: PreferenceProtocol = PreferenceImpl()
    ) {
        self.eventsRemoteDatasource = eventsRemoteDatasource
        self.preference = preference
    }
    
    func postEventDidSucceed(_ eventsResponse: DJEventResponse) {}
    
    func postEventDidFail(_ error: Error) {}
    
    func postEvent(request: DJEventRequest) {
        showLoader?(true)
        eventsRemoteDatasource.postEvent(request: request) { [weak self] result in
            self?.showLoader?(false)
            switch result {
            case let .success(eventsResponse):
                self?.postEventDidSucceed(eventsResponse)
            case let .failure(error):
                self?.showMessage?(.error())
                self?.postEventDidFail(error)
            }
        }
    }
}
