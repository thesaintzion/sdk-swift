//
//  MetaDataRemoteDatasourceProtocol.swift
//
//  Created by AbdulMujeeb on 22/05/2025.
//

import Foundation

protocol MetaDataRemoteDatasourceProtocol {
    func sendMetaData(params: DJParameters, completion: @escaping DJResultAction<SuccessEntityResponse>)
}
