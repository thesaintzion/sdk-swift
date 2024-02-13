//
//  BusinessDataRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 13/02/2024.
//

import Foundation

protocol BusinessDataRemoteDatasourceProtocol {
    func verify(
        type: BusinessDataType,
        params: DJParameters, 
        completion: @escaping DJResultAction<EntityResponse<BusinessDataResponse>>
    )
}
