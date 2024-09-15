//
//  AddressVerificationRemoteDatasourceProtocol.swift
//
//
//  Created by Isaac Iniongun on 08/02/2024.
//

import Foundation

protocol AddressVerificationRemoteDatasourceProtocol {
    func sendAddress(
        type: AddressType,
        params: DJParameters,
        completion: @escaping DJResultAction<SuccessEntityResponse>
    )
}
