//
//  EventsRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

struct EventsRemoteDatasource: EventsRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func postEvent(request: DJEventRequest, completion: @escaping DJResultAction<DJEventResponse>) {
        service.makeRequest(
            responseType: DJEventResponse.self,
            requestMethod: .post,
            remotePath: .events,
            parameters: request.dictionary,
            headers: nil,
            completion: completion
        )
    }
}
