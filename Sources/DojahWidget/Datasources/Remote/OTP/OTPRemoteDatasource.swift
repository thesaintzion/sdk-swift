//
//  OTPRemoteDatasource.swift
//
//
//  Created by Isaac Iniongun on 13/12/2023.
//

import Foundation

struct OTPRemoteDatasource: OTPRemoteDatasourceProtocol {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func requestOTP(params: DJParameters, completion: @escaping DJResultAction<EntityResponse<[OTPRequestResponse]>>) {
        service.makeRequest(
            responseType: EntityResponse<[OTPRequestResponse]>.self,
            requestMethod: .post,
            remotePath: .requestOTP,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
    
    func validateOTP(params: DJParameters, completion: @escaping DJResultAction<EntityResponse<OTPValidationResponse>>) {
        service.makeRequest(
            responseType: EntityResponse<OTPValidationResponse>.self,
            requestMethod: .get,
            remotePath: .validateOTP,
            parameters: params,
            headers: nil,
            completion: completion
        )
    }
}
