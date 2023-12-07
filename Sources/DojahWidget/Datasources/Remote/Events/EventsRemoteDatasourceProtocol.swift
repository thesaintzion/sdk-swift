//
//  EventsRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 07/12/2023.
//

import Foundation

protocol EventsRemoteDatasourceProtocol {
    func postEvent(request: DJEventRequest, completion: @escaping DJResultAction<DJEventResponse>)
}
