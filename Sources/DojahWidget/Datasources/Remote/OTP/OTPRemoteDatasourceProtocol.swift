//
//  OTPRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 13/12/2023.
//

import Foundation

protocol OTPRemoteDatasourceProtocol {
    func requestOTP(params: DJParameters, completion: @escaping DJResultAction<EntityResponse<[OTPRequestResponse]>>)
    
    func validateOTP(params: DJParameters, completion: @escaping DJResultAction<EntityResponse<OTPValidationResponse>>)
}
