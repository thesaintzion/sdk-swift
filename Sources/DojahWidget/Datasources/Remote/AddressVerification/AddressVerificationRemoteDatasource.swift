//
//  AddressVerificationRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

struct AddressVerificationRemoteDatasource: AddressVerificationRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func sendAddress(
        type: AddressType,
        params: DJParameters,
        completion: @escaping DJResultAction<SuccessEntityResponse>
    ) {
        service.makeRequest(
            responseType: SuccessEntityResponse.self,
            requestMethod: .post,
            remotePath: type.remotePath,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
