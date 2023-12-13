//
//  GovernmentDataRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 12/12/2023.
//

import Foundation

protocol GovernmentDataRemoteDatasourceProtocol {
    func lookupID(number: String, idType: DJGovernmentIDType, completion: @escaping DJResultAction<EntityResponse<GovernmentDataLookupEntity>>)
}
