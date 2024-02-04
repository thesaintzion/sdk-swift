//
//  LivenessRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 25/01/2024.
//

import Foundation

protocol LivenessRemoteDatasourceProtocol {
    func performImageAnalysis(
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<ImageAnalysisResponse>>
    )
    
    func performImageCheck(
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<ImageCheckResponse>>
    )
    
    func verifyImage(
        params: DJParameters,
        completion: @escaping DJResultAction<EntityResponse<ImageVerificationResponse>>
    )
    
    func uploadDocument(
        params: DJParameters,
        completion: @escaping DJResultAction<SuccessEntityResponse>
    )
}
